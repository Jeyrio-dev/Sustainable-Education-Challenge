# Sustainable Education Challenge Platform

A blockchain-based contest platform encouraging students to create sustainable solutions for educational environments, including paper reduction and energy efficiency improvements.

## Overview

This smart contract manages sustainability contests where students submit innovative solutions for making education more environmentally friendly. NGO partners can sponsor contests and winners are selected through community voting.

## Features

- **Solution Submissions**: Students submit sustainability projects by category
- **Community Voting**: Transparent voting system for submissions
- **Season Management**: Annual or periodic contest cycles
- **Winner Selection**: Official winner designation with blockchain verification
- **Impact Tracking**: Monitor participation and solution categories

## Contract Functions

### Public Functions

- `submit-solution`: Submit a sustainability solution (one per season)
- `vote-for-submission`: Vote for favorite solutions
- `set-winner`: Designate contest winners (owner only)
- `toggle-contest`: Open/close submission periods (owner only)
- `start-new-season`: Begin new contest cycle (owner only)

### Read-Only Functions

- `get-submission`: Retrieve submission details
- `get-student-submission`: Check if student has submitted
- `get-winner`: View winners by season and rank
- `is-contest-active`: Check if accepting submissions
- `get-current-season`: Get current contest season

## Categories

Solutions can address various sustainability challenges:
- Paper reduction initiatives
- Energy efficiency improvements
- Waste management systems
- Renewable resource usage
- Carbon footprint reduction

## Usage

1. Contest opens for new season
2. Students submit sustainability solutions
3. Community votes on submissions
4. Winners are announced and recorded on blockchain
5. Next season begins with new challenges

## Technology

- Clarity smart contracts
- Stacks blockchain
- Transparent voting and winner selection