# *********************************************
#
# LTBI screening
# N Green
#
# create environments for each set of global
# policy parameter values as inputs


policies <- data.frame()

## WHO incidence groups: subsets
incidence_list <- list(c("(0,50]", "(50,150]", "(150,250]", "(250,350]", "(350,1e+05]"),
                       c("(150,250]", "(250,350]", "(350,1e+05]"),
                       c("(250,350]", "(350,1e+05]"))

## WHO incidence groups: mutually exclusive
# incidence_list <- list(c("(0,50]", "(50,150]", "(150,250]", "(250,350]", "(350,1e+05]"),
#                        c("(50,150]"),
#                        c("(150,250]"),
#                        c("(250,350]"))

## everyone
# incidence_list <- list(c("(0,50]", "(50,150]", "(150,250]", "(250,350]", "(350,1e+05]"))

endpoints <- c("death", "exit uk")

# LTBI_test <- c("QFT_GIT", "QFT_plus", "TSPOT")
# treatment <- c("LTBI_Tx_3mISORIF", "LTBI_Tx_6mISO")


## test:
# incidence_list <- list(c("(0,50]", "(50,150]", "(150,250]"),
#                        c("(250,350]", "(350,1e+05]"))
# endpoints <- c("death")

LTBI_test <- c("TSPOT")
treatment <- c("LTBI_Tx_3mISORIF")


# create policies ---------------------------------------------------------

num_policy <- 1

for (min_screen_length_of_stay in 0) {
  for (incidence in seq_along(incidence_list)) {
    for (endpoint_QALY in seq_along(endpoints)) {
      for (endpoint_cost in endpoint_QALY:length(endpoints)) {
        for (test in LTBI_test) {
          for (treat in treatment) {

            policies <- rbind(policies,
                              cbind(policy = formatC(num_policy, width = 3, format = "d", flag = "0"),
                                    min_screen_length_of_stay,
                                    incid_grps = as.character(incidence_list[incidence]),
                                    treatment = treat,
                                    LTBI_test = test,
                                    endpoint_cost = endpoints[endpoint_cost],
                                    endpoint_QALY = endpoints[endpoint_QALY]))

            environ_name <- sprintf("policy_%s",
                                    formatC(num_policy, width = 3, format = "d", flag = "0"))

            assign(x = environ_name, value = new.env())
            assign(x = "min_screen_length_of_stay", value = min_screen_length_of_stay, envir = eval(parse(text = environ_name)))
            assign(x = "incidence_grps_screen", value = incidence_list[[incidence]], envir = eval(parse(text = environ_name)))
            assign(x = "ENDPOINT_cost", value = endpoints[endpoint_cost], envir = eval(parse(text = environ_name)))
            assign(x = "ENDPOINT_QALY", value = endpoints[endpoint_QALY], envir = eval(parse(text = environ_name)))
            assign(x = "treatment", value = treat, envir = eval(parse(text = environ_name)))
            assign(x = "LTBI_test", value = test, envir = eval(parse(text = environ_name)))

            num_policy %<>% add(1)
          }
        }
      }
    }
  }
}

global_params <-
  policies %>%
  split(seq(nrow(.))) %>%
  lapply(as.list)


# save --------------------------------------------------------------------

save(global_params, file = "data/global_params.RData")
rm(global_params)

write.csv(policies, file = "data/policies-inputs.csv")

rm(list = ls()[!ls() %in% ls(pattern = "policy_")])

save.image(file = "data/policies.RData")

policies_ls <- ls()
save(policies_ls, file = "data/policies_ls.RData")

