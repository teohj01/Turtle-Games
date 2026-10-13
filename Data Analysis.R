# Load the necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(moments)
library(corrplot)
library(stringr)
library(factoextra)
library(cluster)

# Load dataset
df <- read.csv('turtle_reviews.csv', header = T)

#############################################################################
#############################################################################

# Data Cleaning

#############################################################################
# Visualize the data
head(df)

# View the descriptive statistics
summary(df)

# Check column types
str(df)

# View the number of columns and rows
dim(df)

# Visualize columns as dataframe
as_tibble(df)

# Check for missing data
sum(is.na(df))

# Check for duplicates
sum(duplicated(df))

# Remove irrelevant columns
new_df <- df %>% select(-language, - platform)

# Check column names
colnames(new_df)

# Rename columns
new_df <- new_df %>% 
  rename(
    remuneration = remuneration..k..,
    spending_score =  spending_score..1.100.
  )

# Check column names
colnames(new_df)

# Check the types of Education
education_values <- unique(new_df$education)
print(education_values)

# Capitalize the first letter of all the values to maintain consistency
new_df$education <- str_to_title(new_df$education)

# Verify the changes
new_education_values <- unique(new_df$education)
print(new_education_values)

# Remove Review and Summary columns
df_final <- new_df %>% select(- review, - summary)

# Visualize the dataframe
summary(df_final)
head(df_final)

#############################################################################
#############################################################################

# Exploratory Data Analysis

#############################################################################
# Filter the relevant columns.
clients <- df_final %>% select(gender, age, remuneration, spending_score,
                               education, loyalty_points)

# Check for Duplicates.
sum(duplicated(clients))

# Removing Duplicates will give us the unique values of each customer.
clients_final <- unique(clients)

# Visualize the data.
head(clients_final)
summary(clients_final)
dim(clients_final)

#############################################################################
# Univariate Analysis

# Visualize Gender distribution
ggplot(clients_final, aes(x = gender)) + 
  geom_bar(fill = 'skyblue', color = 'black', stat = 'count') +
  geom_text(stat = 'count', aes(label = ..count..), vjust = -0.3) + 
  labs(x = 'Gender',
       y = 'Frequency',
       title = 'Customers per Gender') +
  theme_minimal() +
  theme(panel.grid.major = element_blank())


# Visualize Age distribution
ggplot(clients_final, aes(x = age)) + 
  geom_histogram(binwidth = 10, fill = 'red', color = 'black', alpha = 0.8) + 
  labs(x = "Age",
       y = "Frequency",
       title = "Distribution of Age") + 
  scale_x_continuous(breaks = seq(0, 80, by = 10)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

# Visualize Remuneration distribution
ggplot(clients_final, aes(x = remuneration)) + 
  geom_histogram(binwidth = 10, fill = 'red', color = 'black', alpha = 0.8) + 
  labs(x = "Remuneration (Thousands of Pounds)",
       y = "Frequency",
       title = "Distribution of Remuneration") + 
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 120, by = 10)) + 
  theme(panel.grid.minor = element_blank())

# Visualize Spending Score distribution
ggplot(clients_final, aes(x = spending_score)) + 
  geom_histogram(binwidth = 10, fill = 'red', color = 'black', alpha = 0.8) + 
  labs(x = "Spending Score",
       y = "Frequency",
       title = "Distribution of Spending Score") + 
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 100, by = 10)) + 
  theme(panel.grid.minor = element_blank())

# Visualize Education distribution
ggplot(clients_final, aes(x = education)) + 
  geom_bar(fill = 'skyblue', color = 'black', stat = 'count') +
  geom_text(stat = 'count', aes(label = ..count..), vjust = -0.3) + 
  labs(x = 'Education',
       y = 'Frequency',
       title = 'Customers per Type of Education') +
  theme_minimal() +
  theme(panel.grid.major = element_blank())

# Visualize Loyalty Points distribution
ggplot(clients_final, aes(x = loyalty_points)) + 
  geom_histogram(binwidth = 500, fill = 'red', color = 'black', alpha = 0.8) + 
  labs(x = "Loyalty Points",
       y = "Frequency",
       title = "Distribution of Loyalty Points") + 
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 6500, by = 500)) + 
  theme(panel.grid.minor = element_blank())

#############################################################################
# Bivariate Analysis

# Gender
ggplot(clients_final, aes(x = gender, y = loyalty_points)) + 
  geom_boxplot(fill = 'green', color = 'black') +
  labs(x = 'Gender',
       y = 'Loyalty Points',
       title = 'Loyalty Points by Gender') +
  theme_minimal() +
  theme(panel.grid.major = element_blank())

# Age
ggplot(clients_final, aes(x = age, y = loyalty_points)) + 
  geom_point(color = 'orange', size = 1.5) + 
  geom_smooth(method = 'lm', se = FALSE) +
  labs(x = "Age",
       y = "Loyalty Points",
       title = "Loyalty Points x Age") + 
  scale_x_continuous(breaks = seq(0, 80, by = 10)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

# Remuneration
ggplot(clients_final, aes(x = remuneration, y = loyalty_points)) + 
  geom_point(color = 'orange', size = 1.5) + 
  geom_smooth(method = 'lm', se = FALSE) + 
  labs(x = "remuneration",
       y = "Loyalty Points",
       title = "Loyalty Points x Remuneration") + 
  scale_x_continuous(breaks = seq(0, 120, by = 10)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

# Spending Score
ggplot(clients_final, aes(x = spending_score, y = loyalty_points)) + 
  geom_point(color = 'orange', size = 1.5) + 
  geom_smooth(method = 'lm', se = FALSE) + 
  labs(x = "Spending Score",
       y = "Loyalty Points",
       title = "Loyalty Points x Spending Score") + 
  scale_x_continuous(breaks = seq(0, 100, by = 10)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

# Education
ggplot(clients_final, aes(x = education, y = loyalty_points)) + 
  geom_boxplot(fill = 'green', color = 'black') +
  labs(x = 'Education',
       y = 'Loyalty Points',
       title = 'Loyalty Points by Education Type') +
  theme_minimal() +
  theme(panel.grid.major = element_blank())


# Remuneration - Spending Score
ggplot(clients_final, aes(x = remuneration, y = spending_score)) + 
  geom_point(color = 'orange', size = 1.5) + 
  labs(x = "Remuneration",
       y = "Spending Score",
       title = "Remuneration x Spending Score") + 
  scale_x_continuous(breaks = seq(0, 120, by = 10)) + 
  scale_y_continuous(breaks = seq(0, 100, by = 10)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())

#############################################################################
# Correlation

# Filter Age, remuneration, Spending Score and Loyalty Points
corr_df <- clients_final %>% select(age, remuneration,
                                    spending_score, loyalty_points)

# Calculate the correlation matrix
correlation_matrix <- cor(corr_df)

# Create the correlation plot
corrplot(correlation_matrix, method = 'number')

# Remuneration and Spending score are the factors more related with Loyalty Points. Age has a low relationship.

#############################################################################
# Measures of Shape

# Shapiro - Wilk test
shapiro.test(clients_final$loyalty_points)

# Skewness and Kurtosis
skewness(clients_final$loyalty_points)
kurtosis(clients_final$loyalty_points)

# H0: `loyalty_points` is normally distributed
# H1: `loyalty_points` is *not* normally distributed

# The Shapiro-Wilk test gives p < 0.05, so we reject H0. Skewness of 1.66 shows a highly right skewed distribution, with a long right tail driven by a small group of clients with very high points. Kurtosis of 5.31 indicates heavier tails than normal, suggesting outliers.

#############################################################################
# Variability

# Calculate range
range_loyalty <- range(clients_final$loyalty_points)

# Calculate difference between highest and lowest values
difference_loyalty <- diff(range_loyalty)

# Calculate interquartile Range (IQR)
iqr_loyalty <- IQR(clients_final$loyalty_points)

# Calculate variance
variance_loyalty <- var(clients_final$loyalty_points)

# Calculate Standard Deviation
std_deviation_loyalty <- sd(clients_final$loyalty_points)

# Display results
list(
  Range = range_loyalty,
  Difference = difference_loyalty,
  IQR = iqr_loyalty,
  Variance = variance_loyalty,
  Standard_Deviation = std_deviation_loyalty
)

#############################################################################
# Mean, Median and Mode

# Calculate mean, median and mode.
mean_loyalty <- mean(clients_final$loyalty_points)
median_loyalty <- median(clients_final$loyalty_points)
mode_loyalty <- as.numeric(names(sort(table(clients_final$loyalty_points),
                                      decreasing = TRUE)[1]))

# Print the results
cat("Mean:", mean_loyalty, "\n")
cat("Median:", median_loyalty, "\n")
cat("Mode:", mode_loyalty, "\n")

#############################################################################
#############################################################################

# Multiple Linear Regression

#############################################################################

# Select the numeric columns to be used
df_ml <- clients_final %>% select(age, remuneration,
                                  spending_score, loyalty_points)

# Create the ML regression model
lr_model <- lm(loyalty_points ~ remuneration + spending_score,
             data = df_ml)

# Summarize the model
summary(lr_model)

#############################################################################

# Visualising Model

# Plot actual values and predicted values
ggplot(df_ml, aes(x = loyalty_points, y = predict(lr_model, df_ml))) +
  geom_point(color = 'red', alpha = 0.8) + 
  stat_smooth(method = 'lm', color = 'blue', se = FALSE) + 
  labs(x = 'Actual Loyalty Points',
       y = 'Predicted Loyalty Points',
       title = 'Actual x Predicted Loyalty Points') + 
  theme_minimal() + 
  theme(panel.grid.minor = element_blank())

#############################################################################

# Residual Plot

# Calculate residuals
residuals <- df_ml$loyalty_points - predict(lr_model, df_ml)

# Plot residuals
ggplot(df_ml, aes(x = predict(lr_model, df_ml), y = residuals)) +
  geom_point(color = 'red', alpha = 0.8) + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue") +
  labs(x = 'Predicted Loyalty Points',
       y = 'Residuals',
       title = 'Residual Plot') + 
  theme_minimal() + 
  theme(panel.grid.minor = element_blank())

#############################################################################

# Prediction

# We are going to create a new scenario of 3 new customer purchases
# Purchase 1 - spending_score = 84, remuneration = 35
# Purchase 2 - spending_score = 34, remuneration = 25
# Purchase 3 - spending_score = 55, remuneration = 80

new_purchases <- data.frame(spending_score = c(84, 34, 55),
                            remuneration = c(35, 25, 80))


# Predict loyalty score for the new purchases
predictions <- predict(lr_model, new_purchases)
print(predictions)

# With this model, we can predict loyalty points for new customers.

#############################################################################
#############################################################################

# K-Means Clustering

#############################################################################

# Select the necessary columns (Spending Score x Remuneration)
df_cluster <- clients_final %>% select(spending_score, remuneration)

# Calculate the distance
cluster_distance <- dist(df_cluster)

# Select the optimal number of cluster (k)
fviz_nbclust(df_cluster, kmeans, method = 'wss') + 
  labs(title = 'Elbow Method') + 
  theme_minimal()

# Create the model
model_cluster <- kmeans(df_cluster, centers = 5, nstart = 100)

# Visualize the model
fviz_cluster(model_cluster, data = df_cluster,
             geom = "point",
             ellipse.type = "convex",
             palette = 'jco',
             ggtheme = theme_minimal(),
             main = "K-Means Clustering k=5") +
  labs(x = 'Spending Score',
       y = 'Remuneration')
