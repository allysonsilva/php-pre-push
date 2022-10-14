# PHP [pre-push](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

<p align="center">
    <img src="/images/screenshot.png" alt="Screenshot">
</p>

> CI scripts / code quality that will run on every `git push`

*CI tools that can be run*:

- **PHP_CodeSniffer**
- **PHP Lint**
- **PHPMD - PHP Mess Detector**
- **PHPStan - PHP Static Analysis Tool**
- **PHPUnit – The PHP Testing Framework**

## 🚀 Installation

### Clone the project

Must be cloned to a folder in the project root:

```
$ git clone https://github.com/allysonsilva/php-pre-push code-quality
```

*Note: Folder name in above command is called `code-quality`*

### Configure pre-push hook

Copy the `pre-push` executable to the GIT hooks folder:

```bash
# Create new hooks folder:
mkdir .git/hooks

# Move pre-push to GIT hooks folder:
mv ./code-quality/pre-push .git/hooks/pre-push

# Don't forget to make the pre-push file executable:
chmod +x .git/hooks/pre-push
```

## 🔧 Configuration

A file `.env.prepush` can be created in the project root to have some environment variables that will be used in the execution of each script.

The following variables can be used:

- `run_phpcs`: Boolean `true` or `false` value that will indicate whether the [phpcs](phpcs.sh) script will be executed. Default value `true`.
- `run_phpmd`: Boolean `true` or `false` value that will indicate whether the [phpmd](phpmd.sh) script will be executed. Default value `true`.
- `run_phpstan`: Boolean `true` or `false` value that will indicate whether the [phpstan](phpstan.sh) script will be executed. Default value `true`.
- `run_phpunit`: Boolean `true` or `false` value that will indicate whether the [phpunit](phpunit.sh) script will be executed. Default value `true`.
- `diff_filter`: Value of the `--diff-filter` argument of the `git diff` command. Default value `ACM`.
- `parent_branch`: Source/parent branch, which will be used to compare/recover files that have changed. Default value `main`.

## 📖 Usage

This will work automatically **before every push**.

To execute each command individually it is possible, for example: `./code-quality/phpstan.sh`. Use the arguments of `--diff-filter` or `--branch`.

### PHP Lint(Syntax check)

A bash script that runs `php -l` against stage files that are php. Assumes `php` is a global executable command. Will exit when it hits the first syntax error.

The following command is executed with PHP Lint:

```bash
php -l -d display_errors=On
```

### [PHP CodeSniffer (PHPCS + PHPCBF)](https://github.com/squizlabs/PHP_CodeSniffer)

> PHP_CodeSniffer is a set of two PHP scripts; the main `phpcs` script that tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard, and a second `phpcbf` script to automatically correct coding standard violations. PHP_CodeSniffer is an essential development tool that ensures your code remains clean and consistent.

The following command is executed with PHPCS:

```bash
php ./vendor/bin/phpcs {file}
```

### [PHP Mess Detector (PHPMD)](https://phpmd.org/documentation/index.html)

> PHPMD is a spin-off project of PHP Depend and aims to be a PHP equivalent of the well known Java tool PMD. PHPMD can be seen as an user friendly frontend application for the raw metrics stream measured by PHP Depend.

The following command is executed with PHPMD:

```bash
php ./vendor/bin/phpmd {files} ansi phpmd.xml.dist --suffixes php
```

To generate the [PHPMD baseline](https://phpmd.org/documentation/index.html#baseline), use the `phpmd_generate_baseline=true` environment variable in the `.env.pre-push` file.

### [PHPStan - PHP Static Analysis Tool](https://phpmd.org/documentation/index.html)

> PHPStan scans your whole codebase and looks for both obvious & tricky bugs. Even in those rarely executed if statements that certainly aren't covered by tests.

The following command is executed with PHPStan:

```bash
php ./vendor/bin/phpstan analyse --error-format=table --ansi {files}
```

To generate the [PHPStan baseline](https://phpstan.org/user-guide/baseline), use the `phpstan_generate_baseline=true` environment variable in the `.env.pre-push` file.

### [PHPUnit – The PHP Testing Framework](https://phpunit.de)

> PHPUnit is a programmer-oriented testing framework for PHP. It is an instance of the xUnit architecture for unit testing frameworks.

The following command is executed with PHPUnit:

```bash
php ./vendor/bin/phpunit {files}
```

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
