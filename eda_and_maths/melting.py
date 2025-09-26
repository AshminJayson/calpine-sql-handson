import pandas as pd

df = pd.DataFrame({
    'Date': ['2024-01-01', '2024-01-02'],
    'New Delhi': [35, 32],
    'Chennai': [36, 35]
})

print("Original DataFrame:")
print(df)

melted_df = df.melt(
    id_vars=['Date'], var_name='City', value_name='Temperature')

print("\nMelted DataFrame:")
print(melted_df)
