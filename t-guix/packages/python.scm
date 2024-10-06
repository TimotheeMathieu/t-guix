(define-module (t-guix packages python)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages check)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages python-xyz)
  #:use-module (srfi srfi-1)
  #:use-module (gnu packages web)
  )

;; adds poetry v1.7.1 from https://issues.guix.gnu.org/71540#0


(define-public python-installer
  (package
    (name "python-installer")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "installer" version))
       (sha256
        (base32 "0cdnqh3a3amw8k4s1pzfjh0hpvzw4pczgl702s1b16r82qqkwvd2"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-flit-core python-pytest))
    (home-page "https://installer.rtfd.io/")
    (synopsis "A library for installing Python wheels.")
    (description
     "This package provides a low-level library for installing a Python
package from a wheel distribution. It provides basic functionality and
abstractions for handling wheels and installing packages from wheels.")
    (license license:expat)))

(define-public python-poetry-plugin-export
  (package
    (name "python-poetry-plugin-export")
    (version "1.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "poetry_plugin_export" version))
       (sha256
        (base32 "0qgw6w4xaw7cz9ykw376c5hcg9v2k30lnmna6pc9b4ymhn51d9hz"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-poetry-core))
    (propagated-inputs (list poetry-next python-poetry-core))
    (home-page "https://python-poetry.org/")
    (synopsis "Poetry plugin to export dependencies")
    (description "This package provides a Poetry plugin that allows the export
of locked packages to various formats.  This plugin provides the same features
as the existing @code{export} command of Poetry which it will eventually
replace.")
    (license license:expat)))

 
(define-public python-poetry-plugin-export-minimal
  (hidden-package
   (package
     (inherit python-poetry-plugin-export)
     (name "python-poetry-plugin-export-minimal")
     (arguments (list #:tests? #f
                      #:phases #~(modify-phases %standard-phases
                                   (delete 'sanity-check))))
     (propagated-inputs '()))))


(define-public python-rapidfuzz
  (package
    (name "python-rapidfuzz")
    (version "3.9.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "rapidfuzz" version))
       (sha256
        (base32 "1qh6in6jsybzf414d9samh34npkx34qc95srrqdlal7dx1kfm65k"))))
    (build-system python-build-system)
    (native-inputs (list python-hypothesis python-pytest python-scikit-build))
    (home-page "https://github.com/rapidfuzz/RapidFuzz")
    (synopsis "Rapid fuzzy string matching for Python")
    (description "RapidFuzz is a fast string matching library for Python and
C++, which is using the string similarity calculations from FuzzyWuzzy.")
    (license license:expat)))

(define-public python-poetry-core-next
  (hidden-package
   (package
     (inherit python-poetry-core)
     (version "1.9.0")
     (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "poetry_core" version))
        (sha256
         (base32 "18imz7hm6a6n94r2kyaw5rjvs8dk22szwdagx0p5gap8x80l0yps")))))))


 (define-public python-cleo-next
   (package
     (name "python-cleo")
     (version "2.1.0")
     (source (origin
               (method url-fetch)
               (uri (pypi-uri "cleo" version))
               (sha256
                (base32
                "08ym7xaalxzka3k9wp7i05n6j9xmmjs1y02ilrz0lrhkbl5qhb0b"))
              (modules '((guix build utils)))
              (snippet
               #~(substitute* "pyproject.toml"
                   (("crashtest = \".*\"") "crashtest = \"^0.3.1\"")))))
    (build-system pyproject-build-system)
     (native-inputs
     (list python-crashtest
           python-mock
           python-poetry-core
           python-pytest-mock
           python-pytest))
    (propagated-inputs (list python-rapidfuzz))
     (home-page "https://github.com/sdispater/cleo")
     (synopsis "Command-line arguments library for Python")
     (description
     "Command-line arguments library for Python.")
    (license #f)))

 (define-public poetry-next
   (package
     (name "poetry-next")
    (version "1.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "poetry" version))
       (sha256
        (base32
         "0cpzsqjv8c6v9888svxiyi6c516zqrdjbsnhsc5rrbb7gl7afj5k"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:phases #~(modify-phases %standard-phases
                   ;; Almost every dependency is pinned too strictly.
                   (delete 'sanity-check))
      #:test-flags
      #~(list
         "--ignore=tests/installation/test_executor.py"
         "--ignore=tests/installation/test_chef.py"
         "--ignore=tests/installation/test_chooser.py"
         "--ignore=tests/utils/test_authenticator.py"
         "--ignore=tests/publishing/test_uploader.py"
         "--ignore=tests/console/commands/test_search.py"
         "--ignore=tests/repositories/test_legacy_repository.py"
         "--ignore=tests/console/commands/test_publish.py"
         "-k"
         (string-append
          "not test_create_poetry_fails_on_invalid_configuration "
          "and not test_shell "
          "and not test_installer_with_pypi_repository "
          "and not test_builder_setup_generation_runs_with_pip_editable "
          "and not test_check_invalid"))
      ))
    (native-inputs (list python-deepdiff
                         python-httpretty
                         python-pytest
                         python-pytest-mock
                         python-pytest-randomly
                         python-pytest-xdist))
    (propagated-inputs
     (list python-cachecontrol
           python-cachy
           python-cleo-next
           python-crashtest
           python-dulwich
           python-entrypoints
           python-html5lib
           python-fastjsonschema
           python-importlib-metadata
           python-installer
           python-keyring
           python-packaging
           python-pexpect
           python-pip
           python-pkginfo
           python-platformdirs
           python-poetry-core-next
           python-poetry-plugin-export-minimal
           python-pypa-build
           python-pyproject-hooks
           python-requests
           python-requests-toolbelt
           python-shellingham
           python-tomli
           python-tomlkit
           python-trove-classifiers
           python-virtualenv
           python-xattr))
    (home-page "https://python-poetry.org")
    (synopsis "Python dependency management and packaging made easy")
    (description "Poetry is a tool for dependency management and packaging")
    (license license:expat)))


