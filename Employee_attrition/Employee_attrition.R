install.packages("tdiyverse")
library(tidyverse)

df <- read.csv("employee_attirtion.csv")

View(head(df))

colnames(df)

str(df)

summary(df)

# we found 2 column which are not useful, employeecount and X

df <- df %>% select(-EmployeeCount)
df <- df %>% select(-X.)
df <- df %>% select(-EmployeeID)

colSums(is.na(df))


sum(duplicated(df))

df[duplicated(df), ] # it return if duplicated exist


View(head(df[, c("HourlyRate", "DailyRate", "MonthlyRate", "MonthlyIncome")]))

# This is a bias, due to the lack of documention for this data i removed the 
# hourly rate, daily rate, monthly rate from table and use monthly income as 
# analysis

df <- df %>% select(-HourlyRate, -DailyRate, -MonthlyRate)

# for better analysi we will covert numerical column into factors like
# job satisfaction,JobInvolvement, EnvironmentSatisfaction etc..

unique(df$JobSatisfaction) # find possiblle outcome

df$JobSatisfaction <- factor(df$JobSatisfaction,
                             levels = c(1,2,3,4),
                             labels = c("Dissatisfied", "Neutral", "Satisfied", "Very Satisfied"))
unique(df$Education)

df$Education <- factor(df$Education,
                       levels = c(1,2,3,4,5),
                       labels = c("No college","College","Bachelor's","Master's", "PhD"))


unique(df$EnvironmentSatisfaction)

df$EnvironmentSatisfaction <- factor(df$EnvironmentSatisfaction,
                             levels = c(1,2,3,4),
                             labels = c("Dissatisfied", "Neutral", "Satisfied", "Very Satisfied"))

unique(df$JobInvolvement)

df$JobInvolvement <- factor(df$JobInvolvement, 
                            levels = c(1, 2, 3, 4), 
                            labels = c("Low", "Moderate", "High", "Very High"))

unique(df$JobLevel)

df$JobLevel <- factor(df$JobLevel, 
                      levels = c(1, 2, 3, 4, 5), 
                      labels = c("Entry-Level", "Junior-Level", "Mid-Level", "Senior-Level", "Executive-Level"))

# we are creating sepreate column for category rather than editing this we think if 
# edit if will be a bias

unique(df$DistanceFromHome)


df$DistanceCategory <- cut(df$DistanceFromHome,
                           breaks = c(0,10,20,30,Inf), # inf mean any value > 30
                           labels = c("Short","Medium","High","Very High"),
                           right = TRUE) # True mean 0 and '10' included


sort(unique(df$Age), decreasing = TRUE)


df$AgeCategory <- cut(df$Age, 
                      breaks = c(18, 25, 35, 45, 60, Inf), 
                      labels = c("Young Adults", "Adults", "Middle-Aged", "Older Adults", "Seniors"), 
                      right = TRUE )

# now we have to convert char into factors which is esseintial 

factor_column <- sapply(df, is.character) 
df[factor_column] <- lapply(df[factor_column], as.factor)


# lapply() applies a function to each element and always returns a list.
# sapply() applies a function to each element and tries to simplify the result (to a vector or matrix).

hist(df$MonthlyIncome, main = "Distribution of Monthly Income", xlab = "Monthly Income", col = "lightblue")
boxplot(df$MonthlyIncome, main = "Boxplot of Monthly Income", ylab = "Monthly Income")

# here we have outliers so we will create diffrent type

summary(df$MonthlyIncome)

df$IncomeCategory <- cut(df$MonthlyIncome, 
                         breaks = c(-Inf, 2928, 4899, 8380, Inf), 
                         labels = c("Low", "Medium", "High", "Very High"), 
                         right = TRUE)


# now reorder the columns 
df <- df[, c(
  "Age", 
  "Gender", 
  "MaritalStatus", 
  "Education", 
  "EducationField", 
  "JobLevel", 
  "JobRole", 
  "BusinessTravel", 
  "Department", 
  "JobSatisfaction", 
  "JobInvolvement", 
  "EnvironmentSatisfaction", 
  "DistanceFromHome", 
  "DistanceCategory", 
  "MonthlyIncome", 
  "IncomeCategory", 
  "AgeCategory", 
  "Attrition"
)]


# now we will start analyising table

gender_attrition <- df %>% 
  group_by(Gender,Attrition) %>% 
  summarise(Count = n()) %>% 
  pivot_wider(names_from = Attrition, values_from = Count, values_fill = 0) %>% 
  mutate(Total = Yes + No, Attrition_Rate = round((Yes / Total) * 100,2))

View(gender_attrition)


library(ggplot2)

ggplot(gender_attrition, aes(x = Gender, y = Attrition_Rate, fill = Gender)) +
  geom_bar(stat = "identity") +  # Create bar chart
  geom_text(aes(label = paste0(round(Attrition_Rate, 2), "%")), 
            vjust = -0.5, size = 5) +  # Add percentage labels
  labs(title = "Attrition Rate by Gender", 
       y = "Attrition Rate (%)", x = "Gender") +
  theme_minimal()

# Enviromnet
ggplot(df %>% filter(Attrition == "Yes"), aes(x = Gender, fill = as.factor(EnvironmentSatisfaction))) +
  geom_bar(position = "fill") +  
  labs(title = "Attrition (Yes) by Gender and Environment Satisfaction", 
       x = "Gender", 
       y = "Proportion", 
       fill = "Environment Satisfaction") +
  scale_y_continuous(labels = scales::percent) +  
  scale_fill_manual(values = c("#CCE5FF", "#99CCFF", "#6699FF", "#3366FF")) +  
  theme_minimal()

#job satisfaction


ggplot(df %>% filter(Attrition == "Yes"), aes(x = Gender, fill = as.factor(JobSatisfaction))) +
  geom_bar(position = "fill") +  
  labs(title = "Attrition (Yes) by Gender and Job Satisfaction", 
       x = "Gender", 
       y = "Proportion", 
       fill = "Job Satisfaction") +
  scale_y_continuous(labels = scales::percent) +  
  scale_fill_manual(values = c("#FFCCCC", "#FF6666", "#FF3333", "#CC0000")
) +  
  theme_minimal()


unique(df$JobRole)

attrition_by_role <- df %>%
  filter(Attrition == "Yes") %>%
  group_by(JobRole) %>%
  summarise(AttritionCount = n())

View(attrition_by_role)

ggplot(attrition_by_role, aes(x = JobRole, y = AttritionCount, fill = JobRole)) +
  geom_bar(stat = "identity") +
  labs(title = "Attrition Count by Job Role", 
       x = "Job Role", 
       y = "Attrition Count") +
  theme_minimal()

#Nurse getting 

nurse_attrition_income <- df %>%
  filter(JobRole == "Nurse") %>%
  group_by(IncomeCategory) %>%
  summarise(AttritionCount = sum(Attrition == "Yes"))

View(nurse_attrition_income)

# Plot the attrition count for Nurse role by Income Category
ggplot(nurse_attrition_income, aes(x = IncomeCategory, y = AttritionCount, fill = IncomeCategory)) +
  geom_bar(stat = "identity") +
  labs(title = "Attrition Count for Nurse Role by Income Category", 
       x = "Income Category", 
       y = "Attrition Count") +
  theme_minimal()

# Filter data for Administrative and Therapist roles and group by IncomeCategory
admin_therapist_attrition_income <- df %>%
  filter(JobRole %in% c("Administrative", "Therapist")) %>%
  group_by(JobRole, IncomeCategory) %>%
  summarise(AttritionCount = sum(Attrition == "Yes"))

# Plot the attrition count for Administrative and Therapist roles by Income Category
ggplot(admin_therapist_attrition_income, aes(x = IncomeCategory, y = AttritionCount, fill = IncomeCategory)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ JobRole) +
  labs(title = "Administrative and Therapist", 
       x = "Income Category", 
       y = "Attrition Count") +
  theme_minimal()

# salary count
salary_versa <- df %>% 
  filter(Attrition == "Yes") %>%  # Use == to filter 'Yes' attrition 
  group_by(IncomeCategory) %>%    # Group by IncomeCategory
  summarise(count = n())          # Calculate count of attrition 'Yes' for each IncomeCategory

# Create a bar chart
ggplot(salary_versa, aes(x = IncomeCategory, y = count, fill = IncomeCategory)) +
  geom_bar(stat = "identity") +
  labs(title = "Attrition Count by Income Category", 
       x = "Income Category", 
       y = "Attrition Count") +
  theme_minimal()

age_attrition_travel <- df %>%
  filter(Attrition == "Yes", BusinessTravel == "Travel_Frequently") %>%
  group_by(AgeCategory, Attrition) %>%
  summarise(count = n()) 

View(age_attrition_travel)


ggplot(age_attrition_travel, aes(x = AgeCategory, y = count, fill = AgeCategory)) +
  geom_bar(stat = "identity") +
  labs(title = "Attrition for Employees who Travel Frequently by Age Category",
       x = "Age Category",
       y = "Attrition Count") +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues")

# Group by Education and Attrition, count the number of employees who left (Attrition = Yes)
education_attrition <- df %>%
  group_by(Education, Attrition) %>% 
  summarise(Count = n(), .groups = "drop") %>% 
  filter(Attrition == "Yes") %>%  # Keep only Attrition = "Yes"
  mutate(AttritionRate = (Count / sum(Count)) * 100)  # Calculate attrition rate as percentage

# Create a bar chart visualizing attrition count by education
ggplot(education_attrition, aes(x = Education, y = Count, fill = Education)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Attrition by Education Level",
    x = "Education Level",
    y = "Count of Employees Who Left"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

