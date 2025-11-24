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

;; Data variables
(define-data-var submission-counter uint u0)
(define-data-var contest-active bool true)
(define-data-var current-season uint u1)
(define-data-var max-submissions-per-season uint u100)
(define-data-var min-votes-to-win uint u10)
(define-data-var voting-period-blocks uint u1440)

;; Data maps
(define-map submissions
    { submission-id: uint }
    {
        student: principal,
        category: (string-ascii 50),
        description: (string-ascii 200),
        impact-score: uint,
        votes: uint,
        season: uint,
        timestamp: uint,
        verified: bool,
        mentor: (optional principal)
    }
)

(define-map student-submissions
    { student: principal, season: uint }
    { submitted: bool, submission-id: uint }
)

(define-map votes
    { voter: principal, submission-id: uint }
    { voted: bool }
)

(define-map winners
    { season: uint, rank: uint }
    { submission-id: uint, student: principal, reward: uint }
)

(define-map mentors
    { mentor: principal }
    { verified: bool, students-mentored: uint }
)

(define-map categories
    { category: (string-ascii 50) }
    { active: bool, submissions-count: uint }
)

(define-map season-stats
    { season: uint }
    { 
        total-submissions: uint,
        total-votes: uint,
        start-block: uint,
        end-block: uint,
        completed: bool
    }
)