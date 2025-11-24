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

;; Submit sustainability solution
;; #[allow(unchecked_data)]
(define-public (submit-solution (category (string-ascii 50)) (description (string-ascii 200)))
    (let
        (
            (new-id (+ (var-get submission-counter) u1))
            (season (var-get current-season))
            (current-stats (default-to 
                { total-submissions: u0, total-votes: u0, start-block: stacks-block-height, end-block: u0, completed: false }
                (map-get? season-stats { season: season })))
        )
        (asserts! (var-get contest-active) err-contest-closed)
        (asserts! (is-none (map-get? student-submissions { student: tx-sender, season: season })) err-already-submitted)
        (asserts! (< (get total-submissions current-stats) (var-get max-submissions-per-season)) err-submission-limit-reached)
        
        (map-set submissions
            { submission-id: new-id }
            {
                student: tx-sender,
                category: category,
                description: description,
                impact-score: u0,
                votes: u0,
                season: season,
                timestamp: stacks-block-height,
                verified: false,
                mentor: none
            }
        )
        (map-set student-submissions
            { student: tx-sender, season: season }
            { submitted: true, submission-id: new-id }
        )
        (map-set season-stats
            { season: season }
            (merge current-stats { total-submissions: (+ (get total-submissions current-stats) u1) })
        )
        (var-set submission-counter new-id)
        (ok new-id)
    )
)

;; Vote for submission
;; #[allow(unchecked_data)]
(define-public (vote-for-submission (submission-id uint))
    (let
        (
            (submission (unwrap! (map-get? submissions { submission-id: submission-id }) err-not-found))
            (season (get season submission))
            (current-stats (default-to 
                { total-submissions: u0, total-votes: u0, start-block: stacks-block-height, end-block: u0, completed: false }
                (map-get? season-stats { season: season })))
        )
        (asserts! (is-none (map-get? votes { voter: tx-sender, submission-id: submission-id })) err-already-voted)
        (map-set votes
            { voter: tx-sender, submission-id: submission-id }
            { voted: true }
        )
        (map-set submissions
            { submission-id: submission-id }
            (merge submission { votes: (+ (get votes submission) u1) })
        )
        (map-set season-stats
            { season: season }
            (merge current-stats { total-votes: (+ (get total-votes current-stats) u1) })
        )
        (ok true)
    )
)