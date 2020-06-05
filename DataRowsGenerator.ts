const fs = require('fs');
const _7z = require('7zip-min');
const convert = require('xml-js');

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
    xmlList.forEach((xmlFile) => {
        //Read XML to create an array of rows, cut off XML tags at beginning of file
        const currentXml: string = xmlFile.toLowerCase();
        let splitText: string[] = (fs.readFileSync('./temp/' + xmlFile)).toString('utf-8').split('\n');
        splitText = splitText.slice(2, splitText.length - 1);

        //Generate column names and column data types
        const columnList: string[] = generateColumns(currentXml);
        const dataTypes: string[] = generateTypes(currentXml);

        //Generate SQL queries
        //generateFirstStatement(currentXml, columnList);
        generateInsert(currentXml, splitText, columnList, dataTypes);
        console.log(currentXml + ' processed.');
    });

    fs.appendFileSync('./dataRows.sql', '\nCOMMIT;');
    cleanUp();
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
Generates the INSERT ROW SQL statement for one .xml file.
*/
function generateInsert(currentXml: string, splitText: string[], columnList: string[], dataTypes: string[]): void {
    let query: string = '';

    splitText.forEach((line) => {
        if(currentXml === 'posthistory.xml') {
            query += 'SELECT stackdump.insert_' + currentXml.replace('.xml', '') + '(';
        } else {
            query += 'SELECT stackdump.insert_' + currentXml.replace('s.xml', '') + '(';
        }
        
        const jsonVer = convert.xml2js(line, {compact: true})
        for(let j: number = 0; j < columnList.length; j++) {
            let value: string = jsonVer.row._attributes[columnList[j]];

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
Deletes .xml, .sql and the directory used to hold those files after the query has run.
*/
function cleanUp(): void {
    fs.readdirSync('./temp').forEach((file) => fs.unlinkSync('./temp/' + file));
    fs.rmdirSync('./temp');
}