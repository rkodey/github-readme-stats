// @ts-check
import querystring  from 'node:querystring'
import fs           from "node:fs";
import userStats    from './github-readme-stats/api/index.js';
import repoStats    from './github-readme-stats/api/pin.js';

(async () => {

  const TYPE      = process.argv[2] ?? 'user';
  const FILE      = process.argv[3] ?? 'images/rkodey-test.svg';
  const QUERY     = process.argv[4] ?? 'username=rkodey';
  const query     = querystring.parse(QUERY);
  const noop      = () => {};

  console.log(`get-github ${TYPE} ${FILE}`);

  /**
   * @param { string } svg
   */
  const writeFile = (svg) => {
    // const svg   = (/^\s*(.*?)\s*$/is.exec(res) || [])[1];
    fs.writeFileSync(FILE, svg)
  }


  if (TYPE === 'user') {
    await userStats({ query },
    {
      setHeader     : noop,
      send          : writeFile,
    });
  }
  else if (TYPE === 'repo') {
    await repoStats({ query },
    {
      setHeader     : noop,
      send          : writeFile,
    });
  }
  else {
    console.log(`Unknown type [${TYPE}]`);
  }
})();
