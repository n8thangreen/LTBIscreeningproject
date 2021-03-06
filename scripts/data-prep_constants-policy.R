# **************************************
# project: LTBI screening
# N Green
# Oct 2016
# data-prep_constants-policy.R
#
# simulation specific constants


# policy-level sensitivity parameters -------------------------------------------

if (exists("policy")) {

  interv <- policy_interv(policy_name = policies_ls[policy],
                          interv,
                          diroutput)
}

# subset complete data set ----------------------------------------------
# so can over-write

if (!exists("cohort")) {

  cohort <- policy_cohort(IMPUTED_sample,
                          interv,
                          diroutput)
}

screen_discount <- screen_discount(cohort)

# size potentially screened
pop_year <- nrow(cohort)
