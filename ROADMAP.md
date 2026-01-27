# Roadmap

Documento de planejamento que descreve as etapas p/ esta biblioteca ser um cliente excelente p/ a API Github REST v3.

## Roadmap v1.0.0

Na primeira versão desta biblioteca temos que implementar as funções principais para mnipulação dos recursos do github via REST API v3.

~~Para isso iremos ter o projeto [PyGithub](https://github.com/PyGithub/) como base do desenvolvimento, pois esta biblioteca escrita em Python é muito poderosa e pode nos dar uma boa análise de como codificar a integração com o github via REST API.~~

Não funcionou utilzando a abordagem de utilizar o código PyGithub como base de desenvolvimento, a biblioteca está defasada com relação à api.github.com.json openapi.

Iremos utilizar outra abordagem, utilzando o [openapi-typescript](https://openapi-ts.dev/) podemos gerar todos os tipo e recursos necessários em typescript. Assim, podemos utiliar funções FFI no gleam para fazer a integração com o código gerado.

Com esta biblioteca openapi-typescript conseguimos gerar os tipos e recursos de um arquivo openapi remotamente:

`npx openapi-typescript https://petstore3.swagger.io/api/v3/openapi.yaml -o petstore.d.ts`

Para isso teremos que:

1. Consultar o api.github.com.json no repo [rest-api-descriptions](https://github.com/github/rest-api-description/tree/main/descriptions).
2. Com o arquivo api.github.com.json executar `bunx openapi-typescript api.github.com.json -o github.d.ts`.
3. Gerar funções ffi no gleam p/ realizarmos os fetch na api github.
4. Utilizar o [openapi-fetch](https://openapi-ts.dev/openapi-fetch/) p/ gerar o fetch.

### Desenvolver

- [ ] Incluir lib `bun i -D openapi-typescript`
- [ ] Executar c/ setInterval de 24hrs `bunx openapi-typescript https://raw.githubusercontent.com/github/rest-api-description/refs/tags/v2.1.0/descriptions/api.github.com/api.github.com.json -o src/gbr/gh/api`.
- [ ] Manter a versão da api `2.1.0` em uma var env, de forma a ser configurável.
- [ ] Funções
  - [ ] get user
  - [ ] get_repos
  - [ ] get repo by id
  - [ ] get user by id
  - [ ] get pull requests
  - [ ] get issues
  - [ ] get issues comments

## Backlog

- [ ] Github.withLazy()
- [ ] Github.close()
- [ ] Github.requester
- [ ] Github.rate_limiting
- [ ] Github.rate_limiting_resettime
- [ ] Github.get_rate_limit()
- [ ] Github.oauth_scopes
- [ ] Github.get_license()
- [ ] Github.get_licenses()
- [ ] Github.get_events()
- [ ] Github.get_user()
- [ ] Github.get_user_by_id()
- [ ] Github.get_users()
- [ ] Github.get_organization()
- [ ] Github.get_organizations()
- [ ] Github.get_enterprise()
- [ ] Github.get_repo()
- [ ] Github.get_repos()
- [ ] Github.get_project()
- [ ] Github.get_project_column()
- [ ] Github.get_gist()
- [ ] Github.get_gists()
- [ ] Github.get_global_advisory()
- [ ] Github.get_global_advisories()
- [ ] Github.search_repositories()
- [ ] Github.search_users()
- [ ] Github.search_issues()
- [ ] Github.search_code()
- [ ] Github.search_commits()
- [ ] Github.search_topics()
- [ ] Github.render_markdown()
- [ ] Github.get_hook()
- [ ] Github.get_hooks()
- [ ] Github.get_hook_delivery()
- [ ] Github.get_hook_deliveries()
- [ ] Github.get_gitignore_templates()
- [ ] Github.get_gitignore_template()
- [ ] Github.get_emojis()
- [ ] Github.create_from_raw_data()
- [ ] Github.dump()
- [ ] Github.load()
- [ ] Github.get_app()
