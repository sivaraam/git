#ifndef BRANCH_H
#define BRANCH_H

/* Functions for acting on the information about branches. */

/*
 * Creates a new branch, where:
 *
 *   - name is the new branch name
 *
 *   - start_name is the name of the existing branch that the new branch should
 *     start from
 *
 *   - force enables overwriting an existing (non-head) branch
 *
 *   - clobber_head_ok allows the currently checked out (hence existing)
 *     branch to be overwritten; without 'force', it has no effect.
 *
 *   - reflog creates a reflog for the branch
 *
 *   - quiet suppresses tracking information
 *
 *   - track causes the new branch to be configured to merge the remote branch
 *     that start_name is a tracking branch for (if any).
 *
 */
void create_branch(const char *name, const char *start_name,
		   int force, int clobber_head_ok,
		   int reflog, int quiet, enum branch_track track);

enum branch_validation_result {
	/* Flags that convey there are fatal errors */
	VALIDATION_FATAL_BRANCH_EXISTS_NO_FORCE = -3,
	VALIDATION_FATAL_CANNOT_FORCE_UPDATE_CURRENT_BRANCH = -2,
	VALIDATION_FATAL_INVALID_BRANCH_NAME = -1,
	/* Flags that convey there are no fatal errors */
	VALIDATION_PASS_BRANCH_DOESNT_EXIST = 0,
	VALIDATION_PASS_BRANCH_EXISTS = 1,
	VALIDATION_WARN_BRANCH_EXISTS = 2
};

/*
 * Check if 'name' can be a valid name for a branch; die otherwise.
 *
 *   - name is the new branch name
 *
 *   - ref is used to return the full refname for the branch
 *
 * The return values have the following meaning,
 *
 *   - If 'gently' is 0, the function dies in case of a fatal error and returns
 *     flags of 'branch_validation_result' that indicate nonfatal cases, otherwise.
 *     The positive non-zero flag implies that the branch exists.
 *
 *   - If 'gently' is 1, the function doesn't die in case of a fatal error but returns
 *     flags of 'branch_validaton_result' that identify the fatal error. The behaviour
 *     in case of success is same as above.
 *
 */
extern enum branch_validation_result validate_branchname(const char *name, struct strbuf *ref, unsigned gently);

/*
 * Check if a branch 'name' can be created as a new branch.
 *
 *   - name is the new branch name
 *
 *   - ref is used to return the full refname for the branch
 *
 *   - force can be used when it is OK if the named branch already exists.
 *     the currently checkout branch; with 'shouldnt_exist', it has no effect.
 *
 * The return values have the following meaning,
 *
 *   - If 'gently' is 0, the function dies in case of a fatal error and returns
 *     flags of 'branch_validation_result' that indicate nonfatal cases, otherwise.
 *     The positive non-zero flag implies that the branch can be force updated.
 *
 *   - If 'gently' is 1, the function doesn't die in case of a fatal error but returns
 *     flags of 'branch_validaton_result' that identify the fatal error. The behaviour
 *     in case of success is same as above.
 *
 */
extern enum branch_validation_result validate_new_branchname(const char *name, struct strbuf *ref, int force, unsigned gently);

/*
 * Remove information about the state of working on the current
 * branch. (E.g., MERGE_HEAD)
 */
void remove_branch_state(void);

/*
 * Configure local branch "local" as downstream to branch "remote"
 * from remote "origin".  Used by git branch --set-upstream.
 * Returns 0 on success.
 */
#define BRANCH_CONFIG_VERBOSE 01
extern int install_branch_config(int flag, const char *local, const char *origin, const char *remote);

/*
 * Read branch description
 */
extern int read_branch_desc(struct strbuf *, const char *branch_name);

/*
 * Check if a branch is checked out in the main worktree or any linked
 * worktree and die (with a message describing its checkout location) if
 * it is.
 */
extern void die_if_checked_out(const char *branch, int ignore_current_worktree);

/*
 * Update all per-worktree HEADs pointing at the old ref to point the new ref.
 * This will be used when renaming a branch. Returns 0 if successful, non-zero
 * otherwise.
 */
extern int replace_each_worktree_head_symref(const char *oldref, const char *newref,
					     const char *logmsg);

#endif
