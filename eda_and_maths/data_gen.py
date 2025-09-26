import pandas as pd
import numpy as np
import random

# Number of records
n = 1000

# Set random seeds for reproducibility
np.random.seed(42)
random.seed(42)

# Features
customer_ids = [f"CUST{str(i).zfill(4)}" for i in range(1, n+1)]

# Random ages between 18-65
ages = np.random.randint(18, 66, n)

# Generate annual income based on age (more realistic income distribution)


def generate_income_by_age(age):
    if age < 25:
        return np.random.normal(35000, 10000)  # Young professionals
    elif age < 35:
        return np.random.normal(55000, 15000)  # Early career
    elif age < 45:
        return np.random.normal(75000, 20000)  # Mid career
    elif age < 55:
        return np.random.normal(85000, 25000)  # Peak earning years
    else:
        return np.random.normal(70000, 20000)  # Pre-retirement


annual_incomes = []
for age in ages:
    income = generate_income_by_age(age)
    # Ensure minimum income of 20,000
    income = max(income, 20000)
    annual_incomes.append(round(income, 2))

annual_incomes = np.array(annual_incomes)

genders = np.random.choice(["Male", "Female"], n)

# Define items with price ranges
item_price_ranges = {
    "Shirt": (15, 150),
    "Pants": (25, 200),
    "Shoes": (40, 300),
    "Dress": (30, 250),
    "Jacket": (50, 400),
    "Bag": (20, 500)
}

categories = {
    "Shirt": "Clothing", "Pants": "Clothing", "Shoes": "Footwear",
    "Dress": "Clothing", "Jacket": "Clothing", "Bag": "Accessories"
}

# Generate items and purchase amounts based on income
items = []
purchase_amounts = []

for i in range(n):
    income = annual_incomes[i]
    age = ages[i]

    # Higher income people more likely to buy expensive items
    if income > 80000:
        # More shoes, jackets, bags
        item_weights = [0.15, 0.15, 0.20, 0.15, 0.20, 0.15]
    elif income > 50000:
        item_weights = [0.20, 0.20, 0.15, 0.20, 0.15, 0.10]  # Balanced
    else:
        item_weights = [0.25, 0.25, 0.10, 0.25,
                        0.10, 0.05]  # More basic clothing

    item = np.random.choice(
        ["Shirt", "Pants", "Shoes", "Dress", "Jacket", "Bag"],
        p=item_weights
    )
    items.append(item)

    # Calculate purchase amount based on income and item type
    min_price, max_price = item_price_ranges[item]

    # Income factor: higher income = higher spending within item range
    income_factor = min(income / 60000, 3)  # Cap at 3x for very high incomes

    # Age factor: middle-aged people tend to spend more
    if 35 <= age <= 50:
        age_factor = 1.2
    elif age < 25:
        age_factor = 0.8
    else:
        age_factor = 1.0

    # Adjust price range based on factors
    adjusted_min = min_price
    adjusted_max = min_price + (max_price - min_price) * \
        income_factor * age_factor
    adjusted_max = min(adjusted_max, max_price * 2)  # Cap maximum

    purchase_amount = np.random.uniform(adjusted_min, adjusted_max)
    purchase_amounts.append(round(purchase_amount, 2))

item_categories = [categories[item] for item in items]

locations = np.random.choice(
    ["New York", "Los Angeles", "Chicago", "Houston", "Miami"], n)
sizes = np.random.choice(["S", "M", "L", "XL"], n)
colors = np.random.choice(
    ["Red", "Blue", "Green", "Black", "White", "Yellow"], n)
seasons = np.random.choice(["Spring", "Summer", "Fall", "Winter"], n)

# Review ratings influenced by purchase amount relative to income
review_ratings = []
for i in range(n):
    # Higher satisfaction if purchase amount is reasonable for their income
    affordability_ratio = purchase_amounts[i] / \
        (annual_incomes[i] / 12)  # Monthly income

    if affordability_ratio < 0.1:  # Very affordable
        rating = np.random.choice([4, 5], p=[0.3, 0.7])
    elif affordability_ratio < 0.2:  # Affordable
        rating = np.random.choice([3, 4, 5], p=[0.2, 0.4, 0.4])
    elif affordability_ratio < 0.5:  # Moderate
        rating = np.random.choice([2, 3, 4, 5], p=[0.1, 0.3, 0.4, 0.2])
    else:  # Expensive relative to income
        rating = np.random.choice([1, 2, 3, 4], p=[0.2, 0.4, 0.3, 0.1])

    review_ratings.append(rating)

subscription_status = np.random.choice(["Yes", "No"], n)
shipping_types = np.random.choice(["Standard", "Express", "Same-Day"], n)
discount_applied = np.random.choice(["Yes", "No"], n)
promo_code_used = np.random.choice(["Yes", "No"], n)

# Previous purchases influenced by age and income
previous_purchases = []
for i in range(n):
    # Older and higher income customers tend to have more previous purchases
    base_purchases = max(0, int((ages[i] - 18) / 5))  # Age factor
    income_boost = max(
        0, int((annual_incomes[i] - 30000) / 15000))  # Income factor
    total_previous = base_purchases + income_boost + np.random.randint(-2, 5)
    previous_purchases.append(max(0, min(total_previous, 20)))  # Cap at 20

# Payment methods influenced by age and income
payment_methods = []
for i in range(n):
    if annual_incomes[i] > 75000 and ages[i] < 45:
        # High income, younger: more likely to use digital payments
        method = np.random.choice(
            ["Credit Card", "Debit Card", "PayPal", "Apple Pay", "Google Pay"],
            p=[0.4, 0.2, 0.15, 0.15, 0.1]
        )
    elif ages[i] > 50:
        # Older: more traditional payment methods
        method = np.random.choice(
            ["Credit Card", "Debit Card", "PayPal", "Apple Pay", "Google Pay"],
            p=[0.5, 0.3, 0.15, 0.03, 0.02]
        )
    else:
        # Default distribution
        method = np.random.choice(
            ["Credit Card", "Debit Card", "PayPal", "Apple Pay", "Google Pay"],
            p=[0.35, 0.25, 0.2, 0.1, 0.1]
        )
    payment_methods.append(method)

frequencies = np.random.choice(["Weekly", "Fortnightly", "Monthly"], n)

# Create DataFrame
df = pd.DataFrame({
    "Customer ID": customer_ids,
    "Age": ages,
    "Annual Income (USD)": annual_incomes,
    "Gender": genders,
    "Item Purchased": items,
    "Category": item_categories,
    "Purchase Amount (USD)": purchase_amounts,
    "Location": locations,
    "Size": sizes,
    "Color": colors,
    "Season": seasons,
    "Review Rating": review_ratings,
    "Subscription Status": subscription_status,
    "Shipping Type": shipping_types,
    "Discount Applied": discount_applied,
    "Promo Code Used": promo_code_used,
    "Previous Purchases": previous_purchases,
    "Payment Method": payment_methods,
    "Frequency of Purchases": frequencies
})

# -------------------------
# Introduce Missing Values
# -------------------------
for col in df.columns:
    frac = random.uniform(0.002, 0.02)  # Random fraction between 0.2% to 2%
    df.loc[df.sample(frac=frac, random_state=random.randint(
        1, 100)).index, col] = np.nan

# -------------------------
# Introduce Inconsistencies
# -------------------------
# Lowercase some genders
df.loc[df.sample(frac=0.03).index, "Gender"] = df["Gender"].str.lower()

# Add trailing spaces in "Location"
df.loc[df.sample(frac=0.03).index, "Location"] = df["Location"] + "  "

# Introduce typo in "Subscription Status"
df.loc[df.sample(frac=0.02).index, "Subscription Status"] = "Yess"

# Wrong category for some items
df.loc[df.sample(frac=0.02).index, "Category"] = "Unknown"

# Negative purchase amounts
df.loc[df.sample(frac=0.02).index, "Purchase Amount (USD)"] *= -1

# Non-numeric review ratings
df.loc[df.sample(frac=0.02).index, "Review Rating"] = "Five"

# Inconsistent annual income (some negative or unrealistic values)
# df.loc[df.sample(frac=0.01).index, "Annual Income (USD)"] *= -1
# df.loc[df.sample(frac=0.01).index, "Annual Income (USD)"] = 999999999

# -------------------------
# Introduce Duplicate Rows
# -------------------------
# Create duplicate rows by sampling a fraction of the dataset
duplicate_fraction = 0.05  # 5% of rows will be duplicated
num_duplicates = int(n * duplicate_fraction)
duplicate_indices = np.random.choice(
    df.index, size=num_duplicates, replace=False)
duplicate_rows = df.loc[duplicate_indices].copy()

# Append duplicate rows to the dataset
df = pd.concat([df, duplicate_rows], ignore_index=True)

# -------------------------
# Save the Dataset
# -------------------------
df.to_csv("customer_purchase_dataset.csv", index=False)
print("Dataset with missing values & inconsistencies saved as customer_purchase_dataset.csv")
print(f"\nDataset Summary:")
print(f"Total records: {len(df)}")
print(f"Age range: {df['Age'].min()}-{df['Age'].max()}")
print(
    f"Income range: ${df['Annual Income (USD)'].min():,.2f}-${df['Annual Income (USD)'].max():,.2f}")
print(
    f"Purchase amount range: ${df['Purchase Amount (USD)'].min():.2f}-${df['Purchase Amount (USD)'].max():.2f}")
