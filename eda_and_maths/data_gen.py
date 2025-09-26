import pandas as pd
import numpy as np
import random

# Number of records
n = 500

# Set random seeds for reproducibility
np.random.seed(42)
random.seed(42)

# Features
customer_ids = [f"CUST{str(i).zfill(4)}" for i in range(1, n+1)]

# Normal distribution for ages (mean=35, std=12, clipped to 18-65 range)
ages = np.clip(np.random.normal(35, 12, n).astype(int), 18, 65)

genders = np.random.choice(["Male", "Female"], n)
items = np.random.choice(
    ["Shirt", "Pants", "Shoes", "Dress", "Jacket", "Bag"], n)

categories = {
    "Shirt": "Clothing", "Pants": "Clothing", "Shoes": "Footwear",
    "Dress": "Clothing", "Jacket": "Clothing", "Bag": "Accessories"
}
item_categories = [categories[item] for item in items]

# Normal distribution for purchase amounts (mean=150, std=75, clipped to positive values)
purchase_amounts = np.round(np.clip(np.random.normal(150, 75, n), 10, 500), 2)

locations = np.random.choice(
    ["New York", "Los Angeles", "Chicago", "Houston", "Miami"], n)
sizes = np.random.choice(["S", "M", "L", "XL"], n)
colors = np.random.choice(
    ["Red", "Blue", "Green", "Black", "White", "Yellow"], n)
seasons = np.random.choice(["Spring", "Summer", "Fall", "Winter"], n)

# Normal distribution for review ratings (mean=3.5, std=1, clipped to 1-5 range)
review_ratings = np.clip(
    np.round(np.random.normal(3.5, 1, n)), 1, 5).astype(int)

subscription_status = np.random.choice(["Yes", "No"], n)
shipping_types = np.random.choice(["Standard", "Express", "Same-Day"], n)
discount_applied = np.random.choice(["Yes", "No"], n)
promo_code_used = np.random.choice(["Yes", "No"], n)

# Normal distribution for previous purchases (mean=5, std=3, clipped to 0-20 range)
previous_purchases = np.clip(
    np.round(np.random.normal(5, 3, n)), 0, 20).astype(int)

payment_methods = np.random.choice(
    ["Credit Card", "Debit Card", "PayPal", "Apple Pay", "Google Pay"], n)
frequencies = np.random.choice(["Weekly", "Fortnightly", "Monthly"], n)

# Create DataFrame
df = pd.DataFrame({
    "Customer ID": customer_ids,
    "Age": ages,
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
