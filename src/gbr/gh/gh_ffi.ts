/**
 * Github openapi rest v3 FFI functions.
 *
 * @module gh_ffi
 */

import fs from "node:fs"
import openapiTS, { astToString } from "openapi-typescript"

/** Github api live url */
const ghApiBaseUrl_ = "https://api.github.com"

/** Github openapi spec url */
const ghApiOasUrl = "https://raw.githubusercontent.com/github/rest-api-description/refs/tags/v2.1.0/descriptions/api.github.com/api.github.com.json"

/** Github api client instance */
let client: any = undefined;

/**
 * Fetch github api by url, method and options.
 *
 */
export async function api_github_oas_fetch(url = "/", method = "GET", options = {}): Promise<any> {
  if (client === undefined) {
    //await api_github_oas_load("./src/gbr/gh/gh_oas.ts")
    const { api_github_oas_client } = await import("./gh_oas.ts")

    client = api_github_oas_client()
  }

  const { data, error, response } = await client[method](url, options);

  // console.log(response.ok) // bool
  // console.log(response.url) // string
  // console.log(response.type) // string 'basic'
  // console.log(response.redirected) // bool

  console.log(`${response.status} ${response.statusText}`)

  if (error) throw new Error(error.message)

  //console.log(data)

  return data
}

/**
 * Github openapi spec load and write to file in output.
 *
 * Write the
 *
 */
export async function api_github_oas_load(output: string): Promise<void> {
  if (!output) {
    throw new Error("Output para not found or is empty!")
  }

  const ast = await openapiTS(new URL(ghApiOasUrl), { makePathsEnum: false });
  const datetime = new Date().toISOString()

  fs.writeFileSync(
    output,
    `/*
......................=#%%*:...............................
....................:#@%##@@+..............................
....................=@%****%@#.............................
...................:@@#+=+**#@@=...........................
...................*@#*===+***@@#..........................
..................-@@*=====+***%@%-........................
..................@@*=---==++***#@@*:......................
.................*@#=-::--==+++***#@@@@@@@@@@@@@@@%+:......
................+@@-:.:::--=++++************######%@%:.....
.............+#@@%-:...:::--=++++++************###%@@-.....
........:*%@@@%+-:......::--==+++++++++++++++*###%@@*......
....-#@@@@%*+=:.........:::--=+++++++++++++======@@*.......
..+@@@#*++=::::::......::::::.:::::::::::::-===+@@+........
.:@@#**+=====--::::..........:::::-++=-:::-===+@@=.........
.:%@%%##**+++=-:...........::::::*%*+#%=:-===*@@-..........
..:*@@@%##*+-:::::-#%%#=::::::::=%+:::++-===*@%-...........
.....+@@@#==--:::-@*::+@=::-::++::::::::-===@%-............
.......-%@@*====--%-:::-::=#++#%:::::::-===+@#:............
.........:#@@#==-::::::::::-**=-=+++++++####@@=............
............#@@*=-:::::::::-=+++++++++++*###%@#:...........
.............-@%+=-::::::-+++++++++++++++*##%@@-...........
.............:%@+=-::::-++++++++++++++++++###%@#...........
.............:#@+=-::-=++++**########***++*##%@@=..........
..............#@*==:-+++*#####################%@@..........
..............*@*==-++*#####%%@@@@@@%%#########@@=.........
..............+@*==+######%@@@#-:-*%@@@@@@%%##%@@-.........
..............=@#=+#####%@@%=..........:=#@@@@@@-..........
..............=@#=*##%@@@#:................................
..............:%@*%%@@%=...................................
...............:*%%%*:.....................................

> with love by Gleam BR

###########################################################
# Code auto generate by 'gbr_gh' library:
#> ${datetime}
###########################################################
*/

import createClient, { type Client } from "openapi-fetch";

/**
 * Create github openapi client
 */
export function api_github_oas_client(): Client<paths, \`\${string}/\${string}\`> {
  return createClient<paths>({ baseUrl: "${ghApiBaseUrl_}" });
};

${astToString(ast)}

`);
}
