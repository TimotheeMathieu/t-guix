(define-module (t-guix packages zathura)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages texlive)
  #:use-module (gnu packages pdf)
  #:use-module (srfi srfi-1)
  )

(define (package-with-configure-flags p flags)
  "Return P with FLAGS as additional 'configure' flags."
  (package/inherit p
    (arguments
     (substitute-keyword-arguments (package-arguments p)
       ((#:configure-flags original-flags #~(list))
        #~(append #$original-flags #$flags))))))




(define-public zathura-synctex
  (package
    (inherit (package-with-configure-flags zathura
                                           #~(list "-Dsynctex=enabled")))
    (native-inputs (modify-inputs (package-native-inputs zathura)
                   (prepend texlive))) ;; clean this up by finding exactly which packages are needed
    (name "zathura-synctex"))
  )

(define-public zathura-synctex-pdf-mupdf
   (package
    (inherit (package-with-configure-flags zathura-pdf-mupdf
                                           #~(list "")))
    (inputs (modify-inputs (package-inputs zathura-pdf-mupdf)
                           (delete "zathura")
                   (prepend zathura-synctex)))
    (name "zathura-synctex-pdf-mupdf"))
  )

