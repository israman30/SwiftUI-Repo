### To consider:
1. How risky is it? What has the original author done to mitigate risk?
2. What was the intention? When the original author changed the code, what was s/he attempting to accomplish?

## Arlo's Commit Notation Cheat Sheet:
- F!! | Feature > 8 LoC
- F - | Feature <= 8 LoC
- B!! | Bug Fix > 8 LoC
- B - | Bug Fix <= 8 LoC
- R!! | Non-provable refactoring
- R - | Test-supported procedural refactoring
- r - | Provable refactoring (automated, or from published recipe)
- d - | Developer-visible documentation
- a - | Automatic formatting/generation
- e - | Environment (non-code) changes that affect development setup
- t - | Test-only
- _*  | Known to be broken, or can't check now. 

_ref https://github.com/RefactoringCombos/ArlosCommitNotation_
