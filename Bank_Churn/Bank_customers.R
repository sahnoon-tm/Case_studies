# install packages

install.packages("tidyverse")
library(tidyverse)

#load data
df <- read.csv('Bank Customer Churn Prediction.csv')

View(head(df))

colnames(df)

# There are some numerical column which need to be converted into factor

df$credit_card <- factor(df$credit_card,
                         levels = c(0,1),
                         labels = c("No","Yes"))

df$active_member <- factor(df$active_member,
                           levels = c(0,1),
                           labels = c("Inactive","Active"))

df$churn <- factor(df$churn,
                   levels = c(0,1),
                   labels = c("Retained","Churned"))

str(df)

# check for dupicate or null value / missing values

sum(duplicated(df))

sum(is_null(df))

sum(is.na(df))

sort(unique(df$age))

# create age category for customers

df$age_category <- cut(df$age, 
                       breaks = c(18, 25, 35, 45, 55, 65, Inf), 
                       labels = c("Young Adult", 
                                  "Early Career", 
                                  "Mid-Career", 
                                  "Experienced", 
                                  "Senior Professional", 
                                  "Retired"),
                       right = TRUE)

# find the maximum and minimum salary for cateforizing salary

min(df$estimated_salary) # 11.58
max(df$estimated_salary) # 199992.5

# here we could see the diffrence which is much higher and lets check for the outliers

q1 <- quantile(df$estimated_salary, 0.25)
q3 <- quantile(df$estimated_salary, 0.75)
IQR <- q3 - q1

lower_bound <- q1 - 1.5 * IQR
upper_bound <- q3 + 1.5 * IQR

outliers <- df[df$estimated_salary < lower_bound | df$estimated_salary > upper_bound, ]

outliers

# no data printing checking is there any errors 

min(df$estimated_salary)# 11.58
lower_bound#  -96577.1

max(df$estimated_salary)# 199992.5
upper_bound# 296967.5 

# Based on the output there is no outliers among the data set, so we can categorize them

df$income_category <- cut(df$estimated_salary,
                          breaks = c(0, 50000, 100000 ,150000 ,Inf),
                          labels = c("Low",
                                     "Middle",
                                     "High",
                                     "Very High"),
                          right = TRUE)


# reorder coloumn for better visibility and access 

df <- df[, c("customer_id","country", "gender", "age", "age_category",
             "credit_score", "balance", "estimated_salary", "income_category",
             "tenure", "products_number", "credit_card", "active_member",
             "churn")]


# * What percentage of customers have churned ?

churn_summary <- df %>% 
  group_by(churn) %>% 
  summarise(total_count = n()) %>% 
  mutate(percentage = round((total_count / sum(total_count)) * 100, 2))

View(churn_summary)

ggplot(churn_summary, aes(x = 2, y = percentage, fill = churn)) +
  geom_bar(stat = "identity") +  # Bar chart base
  coord_polar("y", start = 0) +  # Convert to pie chart
  labs(fill = "Churn Status") +
  theme_void() +  # Remove background elements
  geom_text(aes(label = paste0(round(percentage, 1), "%")), 
            position = position_stack(vjust = 0.5), size = 5) +  # Add percentage labels
  scale_fill_manual(values = c("cyan", "coral")) +
  xlim(0.5, 2.5) 

# How does churn vary by age, tenure, balance, 
# credit score, and estimated salary ?

churn_summary_2 <- df %>% 
  group_by(churn) %>% 
  summarise(
    avg_age = mean(age),
    avg_tenure = mean(tenure),
    avg_balance = mean(balance),
    avg_credit_score = mean(credit_score),
    avg_salary = mean(estimated_salary)
  )

View(churn_summary_2)

# Which age groups have the highest churn rates?

age_wise_churn <- df %>% 
  filter(!is.na(age_category)) %>% 
  group_by(age_category) %>% 
  summarise(
    total_person = n(),
    total_chunred = sum(churn == "Churned")
  ) %>% 
  arrange(-total_chunred)

View(age_wise_churn)

ggplot(age_wise_churn, aes(x=reorder(age_category, total_chunred), y = total_chunred, fill = age_category)) +
  geom_bar(stat = "identity") +
  labs(x = "Age Category", y = "Total Churn") +
  theme_minimal() +
  coord_flip()

# Which income groups have the highest churn rates?

income_wise_churn <- df %>% 
  group_by(income_category) %>% 
  summarise(
    total_person = n(), 
    total_churned = sum(churn == "Churned"),
    churn_percentage = round((total_churned / total_person) * 100,2)
  ) %>% 
  arrange(-total_churned) 

View(income_wise_churn)


ggplot(income_wise_churn, aes(x = "", y = churn_percentage, fill = income_category)) +
  geom_bar(stat = "identity", width = 1) +  
  coord_polar(theta = "y") +  
  labs(title = "Churn Percentage by Income Category", fill = "Income Category") +
  theme_void()  

# why does mid-career people leaving ?

mid_career_summary <- df %>% 
  filter(churn == "Churned", age_category == "Mid-Career") %>% 
  summarise(
    avg_cred = mean(credit_score, na.rm = TRUE),
    avg_balance = mean(balance, na.rm = TRUE),
    avg_salary = mean(estimated_salary, na.rm = TRUE),
    avg_tenure = round(mean(tenure, na.rm = TRUE)),
    avg_product = round(mean(products_number, na.rm = TRUE)),
    avg_cred_count = sum(credit_card == "Yes", na.rm = TRUE),
    total_person = n()
  ) %>%
  ungroup() %>%
  mutate(across(everything(), as.numeric))  # Ensure numeric types

mid_career_summary_long <- mid_career_summary %>%
  pivot_longer(
    cols = everything(), 
    names_to = "Metric", 
    values_to = "Value"
  )

View(mid_career_summary_long)

ggplot(mid_career_summary_long, aes(x = reorder(Metric, Value), y = Value, fill = Metric)) +
  geom_bar(stat = "identity", width = 0.6, show.legend = FALSE) +  # Bar chart without legend
  geom_text(aes(label = round(Value, 2)), vjust = -0.5, size = 5) +  # Add value labels
  theme_minimal() +
  labs(
    x = "Metric",
    y = "Value"
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels

# * Does tenure influence churn?

tenure_summary <- df %>% 
  group_by(churn) %>% 
  summarise(
   avg_tenure = round(mean(tenure, na.rm = TRUE))
  )

View(tenure_summary)


ggplot(tenure_summary, aes(x = churn, y = avg_tenure, fill = churn)) +
  geom_bar(stat = "identity", width = 0.6, show.legend = FALSE) +
  theme_minimal() +
  labs( x = "Churn Status", y = "Average Tenure")

# * Do customers with multiple bank products churn less?

product_summary <- df %>% 
  group_by(churn) %>% 
  summarise(
    avg_product = round(mean(products_number, na.rm = TRUE)),
    most_product = names(which.max(table(products_number)))
  )

View(product_summary)

ggplot(product_summary, aes(x = churn, y = avg_product, fill = churn)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(x = 'Churn status', y = 'Average Product')

#* Are higher or lower credit scores linked to churn?

credit_score_summary <- df %>%
  group_by(credit_score) %>%
  summarise(
    Churned = sum(churn == "Churned"),
    Retained = sum(churn == "Retained")
  ) %>%
  pivot_longer(cols = c(Churned, Retained), names_to = "Churn_Status", values_to = "Count")

View(credit_score_summary)

ggplot(df, aes(x = credit_score, fill = churn)) +
  geom_density(alpha = 0.5) +
  labs(x = "Credit Score",
       y = "Density") +
  theme_minimal()


#* Does churn differ by gender?
#* 
gender_summary <- df %>% 
  group_by(gender) %>% 
  summarise(total_count = n(),
            total_churn = sum(churn == "Churned",  na.rm = TRUE),
            churn_rate = round((total_churn / total_count) * 100,2))

View(gender_summary)

ggplot(gender_summary, aes(x = gender, y = churn_rate, fill = gender))+
  geom_bar(stat = "identity") +
  labs(x = "Gender", y = "Chrun Rate") +
  theme_minimal()

# why does female leave most ?

# Female summary
female_summary <- df %>% 
  filter(churn == "Churned", gender == "Female") %>% 
  summarise(
    avg_cred = mean(credit_score, na.rm = TRUE),
    avg_balance = mean(balance, na.rm = TRUE),
    avg_salary = mean(estimated_salary, na.rm = TRUE),
    avg_tenure = round(mean(tenure, na.rm = TRUE)),
    avg_product = round(mean(products_number, na.rm = TRUE)),
    avg_cred_count = sum(credit_card == "Yes", na.rm = TRUE),
    total_person = n()
  )

# Convert to long format for visualization
female_summary_long <- female_summary %>%
  pivot_longer(cols = everything(), names_to = "Metric", values_to = "Value")

View(female_summary_long)


# Male summary
male_summary <- df %>% 
  filter(churn == "Churned", gender == "Male") %>% 
  summarise(
    avg_cred = mean(credit_score, na.rm = TRUE),
    avg_balance = mean(balance, na.rm = TRUE),
    avg_salary = mean(estimated_salary, na.rm = TRUE),
    avg_tenure = round(mean(tenure, na.rm = TRUE)),
    avg_product = round(mean(products_number, na.rm = TRUE)),
    avg_cred_count = sum(credit_card == "Yes", na.rm = TRUE),  # Fix applied
    total_person = n()
  )

# Convert to long format for visualization
male_summary_long <- male_summary %>%
  pivot_longer(cols = everything(), names_to = "Metric", values_to = "Value")

View(male_summary_long)


#* Does churn vary by country?

country_summary <- df %>% 
  group_by(country) %>% 
  summarise(total_count = n(),
            total_churn = sum(churn == "Churned",  na.rm = TRUE),
            churn_rate = round((total_churn / total_count) * 100,2))

View(country_summary)

ggplot(country_summary, aes(x = reorder(country, churn_rate), y = churn_rate, group = 1)) +
  geom_line(color = "blue", size = 1.2) +
  geom_point(size = 3, color = "red") +
  labs(x = "Country", y = "Churn Rate (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Why germany ?

country_summary_details <- df %>% 
  filter(churn == "Churned") %>% 
  group_by(country) %>% 
  summarise(
    avg_cred = mean(credit_score, na.rm = TRUE),
    avg_balance = mean(balance, na.rm = TRUE),
    avg_salary = mean(estimated_salary, na.rm = TRUE),
    avg_tenure = round(mean(tenure, na.rm = TRUE)),
    avg_product = round(mean(products_number, na.rm = TRUE)),
    avg_cred_count = sum(credit_card == "Yes", na.rm = TRUE),  # Fix applied
    total_person = n(),
    female_count = sum(gender == "Female", na.rm = TRUE),
    male_count = sum(gender == "Male", na.rm = TRUE)
  )
View(country_summary_details)


# Convert the country_summary_details dataset into a readable format

country_summary_long <- country_summary_details %>%
  pivot_longer(
    cols = -country,  # Convert all metrics except 'country' into long format
    names_to = "Metric",
    values_to = "Value"
  ) %>%
  pivot_wider(
    names_from = country,
    values_from = Value
  )

View(country_summary_long)



# compare country wised based on diffrence 

country_summary <- data.frame(
  Metric = c("avg_balance", "avg_salary", "avg_cred_count"),
  France = c(71192.80, 103439.28, 569),
  Germany = c(120361.08, 98403.89, 577),
  Spain = c(72513.35, 103629.55, 278)
)

View(country_summary)

# Convert Data into Long Format
country_summary_long <- country_summary %>%
  pivot_longer(cols = -Metric, names_to = "Country", values_to = "Value")
View(country_summary_long)

# Heatmap
ggplot(country_summary_long, aes(x = Country, y = Metric, fill = Value)) +
  geom_tile(color = "white") +  
  scale_fill_gradient(low = "black", high = "white") +
  labs(x = "Country", y = "Metrics") +
  theme_minimal()
