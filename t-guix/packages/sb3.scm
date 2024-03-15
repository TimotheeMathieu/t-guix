(define-module (t-guix packages sb3)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages machine-learning)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-science)
  )

(define-public python-stable-baselines3
(package
  (name "python-stable-baselines3")
  (version "2.2.1")
  (source
   (origin
     (method url-fetch)
     (uri (pypi-uri "stable_baselines3" version))
     (sha256
      (base32 "0kcajz92521xbv88n2aiww7iq4y8kfd0aa9m4kclh96887m0pc3x"))))
  (build-system pyproject-build-system)

    (arguments
     `(#:phases (modify-phases %standard-phases
                  ;; (delete 'sanity-check) ;; for some reason, does not pass
                  ;; (replace 'check
                  ;;   (lambda* (#:key tests? inputs outputs #:allow-other-keys)
                  ;;     (when tests?
                  ;;       (add-installed-pythonpath inputs outputs)
                  ;;       (invoke "pytest" "-m" "not expensive"
                  ;;               "-k"
                  ;;               "not test_make_atari_env and not test_set_logger and not test_vec_env_monitor_kwargs"
                  ;;               ))))
                               (delete 'check) ;; too long, but for me it passes
                  )))
  
  (propagated-inputs (list python-cloudpickle
                           python-gymnasium
                           python-matplotlib
                           python-numpy
                           python-pandas
                           python-pytorch
                           python-tqdm
                           python-rich))
  (native-inputs (list zip
                       python-pytest
                       python-pytest-cov
                       python-pytest-env
                       python-pytest-xdist
                       ))
  (home-page "https://github.com/DLR-RM/stable-baselines3")
  (synopsis
   "Pytorch version of Stable Baselines, implementations of reinforcement learning algorithms.")
  (description
   "Pytorch version of Stable Baselines, implementations of reinforcement learning
algorithms.
Note: currently this package does not provide atari or tensorboard support.")
  (license license:expat)))


