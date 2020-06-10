const fs = require('fs');
const _7z = require('7zip-min');
const convert = require('xml-js');
const answerList = [];

//Section 1: Choose Stackexchange dump, download and unzip
//Main function
if(process.argv.length !== 3) {
    console.log('Enter the name of the .7z stackdump file.');
    process.exit(0);
}
if (!fs.existsSync('./temp')) {
    fs.mkdirSync('./temp');
}

new Promise((resolve) => {
    _7z.unpack('./' + process.argv[2], './temp', err => {
        resolve();
    });
}).then(() => {
    if(fs.readdirSync('./' + 'temp').length === 0) {
        console.log('No file unzipped, exiting program.');
        cleanUp();
        process.exit(0);
    }

    console.log('Unzipping complete.');
    generateQueries();
});

//Section 2: Generate and execute queries
function generateQueries(): void {
    //Create schema and get list of xml files
    const xmlList: string[] = ['Users.xml', 'Badges.xml', 'Posts.xml', 'PostLinks.xml', 'Comments.xml', 'Tags.xml', 'PostHistory.xml', 'Votes.xml'];

    const tempFiles: string[] = fs.readdirSync('./temp');
    xmlList.forEach((xmlFile) => {
        if(!tempFiles.includes(xmlFile)) {
            console.log('.7z did not contain the .xml files typical of a stack exchange data dump. Terminating program.');
            cleanUp();
            process.exit(0);
        }
    });

    generateDependencies();
    //Loop through files in folder
    console.log("Processing XML Files:");
    for (let i = 0, p = Promise.resolve(); i < xmlList.length; i++) {
        p = p.then(_ => new Promise(resolve => {
            console.log('Processing ' + xmlList[i] + '...');
            const columnList: string[] = generateColumns(xmlList[i].toLowerCase());
            const dataTypes: string[] = generateTypes(xmlList[i].toLowerCase());
            let splitText: string[] = [];

            let myListener = newLineStream(function(line: string) {
                if(line.length > 40) { //could put a different condition here to check for 1st, 2nd and last lines
                    splitText.push(line);
                    if(splitText.length === 10000) {
                        processArray(splitText, xmlList[i], columnList, dataTypes);
                        splitText = [];
                    }
                }
            })
            
            fs.createReadStream(`./temp/${xmlList[i]}`, 'utf8')
                .on('data', myListener)
                .on('end', () => {
                    processArray(splitText, xmlList[i], columnList, dataTypes);
                    if(i === xmlList.length - 1) {
                        answerList.forEach(function(answer) {
                            fs.appendFileSync('./dataRows.sql', 'SELECT stackdump.insert_answer(' + answer[0] + ',' + answer[1] + ');\n');
                        });
                        fs.appendFileSync('./dataRows.sql', '\nCOMMIT;');
                        cleanUp();
                    }
                    resolve();
                });
        }));
    }
    
}

/*
Splits the stream by newline characters.
*/
function newLineStream(callback) {
	let buffer = '';
	return (function (chunk) {
		let i = 0, piece = '', offset = 0;
		buffer += chunk;
		while ((i = buffer.indexOf('\n', offset)) !== -1) {
			piece = buffer.substr(offset, i - offset);
			offset = i + 1;
			callback(piece);
		}
		buffer = buffer.substr(offset);
	});
}

/*
Processes the lines in the splitText array.
*/
function processArray(splitText: string[], currentXml: string, columnList: string[], dataTypes: string[]) {
    let query: string = '';
    splitText.forEach((line) => {
        const lowerFileName = currentXml.toLowerCase();
        if(lowerFileName === 'posthistory.xml') {
            query += 'SELECT stackdump.insert_' + lowerFileName.replace('.xml', '') + '(';
        } else {
            query += 'SELECT stackdump.insert_' + lowerFileName.replace('s.xml', '') + '(';
        }
        
        const jsonVer = convert.xml2js(line, {compact: true});
        for(let j: number = 0; j < columnList.length; j++) {  
            let value: string = jsonVer.row._attributes[columnList[j]];
            if(columnList[j] === 'AcceptedAnswerId') {
                if(jsonVer.row._attributes[columnList[0]] && value) {
                    answerList.push([jsonVer.row._attributes[columnList[0]], value]);
                }
            }
            if(value) {
                if(dataTypes[j] === 'TEXT') {
                    value = value.replace(/\'/g,'\'\'');
                    query += '\'' + value + '\'';
                } else if(dataTypes[j] === 'INTEGER') {
                    query += value;
                } else if(dataTypes[j] === 'BOOLEAN') {
                    query += value.toLowerCase();
                } else {
                    query += '\'' + value + '\'';
                }
            } else {
                query += 'NULL';
            }

            if(j !== columnList.length - 1) {
                query += ', ';
            }
        }
        query += ');\n';
        
    });
    fs.appendFileSync('./dataRows.sql', query);
}

/*
Generates the requires lines of the output file.
*/
function generateDependencies(): void {
    let query: string = '-- Deploy stackdump:dataRows to pg\n';
    query += '-- requires: appschema\n';
    query += '-- requires: badges\n';
    query += '-- requires: comments\n';
    query += '-- requires: postHistory\n';
    query += '-- requires: postLinks\n';
    query += '-- requires: posts\n';
    query += '-- requires: tags\n';
    query += '-- requires: users\n';
    query += '-- requires: votes\n';
    query += '-- requires: insert_badge\n';
    query += '-- requires: insert_comment\n';
    query += '-- requires: insert_postHistory\n';
    query += '-- requires: insert_postLink\n';
    query += '-- requires: insert_post\n';
    query += '-- requires: insert_tag\n';
    query += '-- requires: insert_user\n';
    query += '-- requires: insert_vote\n';
    query += '\n';
    query += 'BEGIN;\n\n';

    fs.writeFileSync('./dataRows.sql', query);
}

/*
Generates a column list that contains the names of each column.
*/
function generateColumns(currentXml: string): string[] {
    let columnList: string[] = [];
    switch(currentXml) {
        case 'users.xml': {
            columnList = ['Id', 'Reputation', 'CreationDate', 'DisplayName', 'LastAccessDate', 'WebsiteUrl'];
            columnList.push('Location', 'AboutMe', 'Views', 'UpVotes', 'DownVotes', 'ProfileImageUrl', 'AccountId');
            break;
        }
        case 'badges.xml': {
            columnList = ['Id', 'UserId', 'Name', 'Date', 'Class', 'TagBased'];
            break;
        }
        case 'comments.xml': {
            columnList = ['Id', 'PostId', 'Score', 'Text', 'CreationDate', 'UserId'];
            break;
        }
        case 'posts.xml': {
            columnList = ['Id', 'PostTypeId', 'AcceptedAnswerId', 'CreationDate', 'Score', 'ViewCount', 'Body'];
            columnList.push('OwnerUserId', 'OwnerDisplayName', 'LastEditorUserId', 'LastEditDate');
            columnList.push('LastActivityDate', 'Title', 'Tags', 'AnswerCount', 'CommentCount', 'FavoriteCount');
            break;
        }
        case 'posthistory.xml': {
            columnList = ['Id', 'PostHistoryTypeId', 'PostId', 'RevisionGUID', 'CreationDate', 'UserId'];
            columnList.push('UserDisplayName', 'Comment', 'Text');
            break;
        }
        case 'postlinks.xml': {
            columnList = ['Id', 'CreationDate', 'PostId', 'RelatedPostId', 'LinkTypeId'];
            break;
        }
        case 'tags.xml': {
            columnList = ['Id', 'TagName', 'Count', 'ExcerptPostId', 'WikiPostId'];
            break;
        }
        case 'votes.xml': {
            columnList = ['Id', 'PostId', 'VoteTypeId', 'UserId', 'CreationDate', 'BountyAmount'];
            break;
        }
    }
    return columnList;
}

/*
Generates a dataTypes: number[] array that contains the data type of each key.
*/
function generateTypes(currentXml: string): string[] {
    let dataTypes: string[] = [];

    switch(currentXml) {
        case 'users.xml': {
            dataTypes = ['INTEGER', 'INTEGER', 'TIMESTAMP', 'TEXT', 'TIMESTAMP', 'TEXT', 'TEXT', 'TEXT', 'INTEGER'];
            dataTypes.push('INTEGER', 'INTEGER', 'TEXT', 'INTEGER');
            break;
        }
        case 'badges.xml': {
            dataTypes = ['INTEGER', 'INTEGER', 'TEXT', 'TIMESTAMP', 'INTEGER', 'BOOLEAN'];
            break;
        }
        case 'comments.xml': {
            dataTypes = ['INTEGER', 'INTEGER', 'INTEGER', 'TEXT', 'TIMESTAMP', 'INTEGER'];
            break;
        }
        case 'posts.xml': {
            dataTypes = ['INTEGER', 'INTEGER', 'INTEGER', 'TIMESTAMP', 'INTEGER', 'INTEGER', 'TEXT', 'INTEGER'];
            dataTypes.push('TEXT', 'INTEGER', 'TIMESTAMP', 'TIMESTAMP', 'TEXT', 'TEXT', 'INTEGER', 'INTEGER', 'INTEGER');
            break;
        }
        case 'posthistory.xml': {
            dataTypes = ['INTEGER', 'INTEGER', 'INTEGER', 'TEXT', 'TIMESTAMP', 'INTEGER', 'TEXT', 'TEXT', 'TEXT'];
            break;
        }
        case 'postlinks.xml': {
            dataTypes = ['INTEGER', 'TIMESTAMP', 'INTEGER', 'INTEGER', 'INTEGER'];
            break;
        }
        case 'tags.xml': {
            dataTypes = ['INTEGER', 'TEXT', 'INTEGER', 'INTEGER', 'INTEGER'];
            break;
        }
        case 'votes.xml': {
            dataTypes = ['INTEGER', 'INTEGER', 'INTEGER', 'INTEGER', 'TIMESTAMP', 'INTEGER'];
        }
    }
    return dataTypes;
}

/*
Deletes .xml, .sql and the directory used to hold those files after the query has run.
*/
function cleanUp(): void {
    fs.readdirSync('./temp').forEach((file) => fs.unlinkSync('./temp/' + file));
    fs.rmdirSync('./temp');
}