# Cevixe GitHub Actions

Cevixe GitHub Actions allows you to run `cvx deploy` and `cvx diff`

## Example usage

```yaml
on: [push]

jobs:
  aws_cdk:
    runs-on: ubuntu-latest
    steps:

      - name: cvx diff
        uses: cevixe/actions@v1
        with:
          command: 'diff'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'us-east-1'

      - name: cvx deploy
        uses: cevixe/actions@v1
        with:
          command: 'deploy'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: 'us-east-1'
```

## Inputs

- `command` **Required** Actions command to execute.

## Outputs

- `status` Returned status code.

## Environment

- `AWS_ACCESS_KEY_ID` **Required**
- `AWS_SECRET_ACCESS_KEY` **Required**
- `AWS_DEFAULT_REGION` **Required**

## License

[MIT](LICENSE)

## Authors

[Ronnie Ayala](https://github.com/ronnieacs)
[Daniel Miralles](https://github.com/danielmiralles)
[Jesus Sanchez](https://github.com/iesussan)