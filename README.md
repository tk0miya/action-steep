# GitHub Action: Run steep with reviewdog 🐶

This action runs [steep](https://github.com/soutaro/steep) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

## Inputs

### `github_token`

`GITHUB_TOKEN`. Default is `${{ github.token }}`.

### `level`

Optional. Report level for reviewdog [`info`, `warning`, `error`].
The default is `error`.

### `reporter`

Optional. Reporter of reviewdog command [`github-pr-check`, `github-check`, `github-pr-review`].
The default is `github-pr-review`.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [`added`, `diff_context`, `file`, `nofilter`].
Default is `added`.

### `use_bundler`

Optional. Run Steep with bundle exec. Default: `true`.

### `instal_rbs_collection`

Optional. Install rbs collection before steep check. Default: `true`.

### `steep_options`

Optional. Options to `steep check` command. ex. `--steepfile=PATH`. Default: ""

## Example usage

```yml
name: reviewdog
on: [pull_request]
jobs:
  erb-lint:
    name: runner / erb-lint
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.2.0
      - name: steep check
        uses: tk0miya/action-steep@v1
```

## License

[MIT](https://choosealicense.com/licenses/mit)
