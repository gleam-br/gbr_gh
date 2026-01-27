[![Package Version](https://img.shields.io/hexpm/v/gbr_gh)](https://hex.pm/packages/gbr_gh)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gbr_gh/)

# 🔮 Github Rest API client by Gleam BR

It is a library to access the GitHub REST API v3. This library enables you to manage GitHub resources such as repositories, user profiles, and organizations.

> Only target javascript for now!

## Support

- Browsers: See fetch API support (widely-available in all major browsers)
- TypeScript: >= 4.7 (>= 5.0 recommended)
- Node: >= 18.0.0

## :bug: Gleam compiler bug

https://github.com/gleam-lang/gleam/issues/4287

Persist on Windows 11 in look file `./src/gbr/gh/decoder.gleam`, if try `gleam build` throw error:

> thread 'main' has overflowed its stack

```sh
gleam add gbr_gh@1
```

```gleam
import gbr_gh

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/gbr_gh>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
