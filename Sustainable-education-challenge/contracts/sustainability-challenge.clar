;; sustainability-challenge.clar
;; Sustainable education solutions contest management

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-submitted (err u102))
(define-constant err-contest-closed (err u103))
(define-constant err-invalid-category (err u104))
(define-constant err-invalid-score (err u105))
(define-constant err-insufficient-votes (err u106))
(define-constant err-already-voted (err u107))
(define-constant err-invalid-rank (err u108))
(define-constant err-season-not-started (err u109))
(define-constant err-submission-limit-reached (err u110))
(define-constant err-invalid-mentor (err u111))
