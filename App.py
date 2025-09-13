# app.py
import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px

# ---------------------------
# Fake Dataset Generation
# ---------------------------
np.random.seed(42)
dates = pd.date_range(start="2023-01-01", end="2023-12-31", freq="M")
stores = ["Store A", "Store B", "Store C"]
products = ["Electronics", "Clothing", "Groceries"]

data = []
for store in stores:
    for product in products:
        sales = np.random.randint(1000, 5000, size=len(dates))
        for date, sale in zip(dates, sales):
            data.append([store, product, date, sale])

df = pd.DataFrame(data, columns=["Store", "Product", "Date", "Sales"])

# ---------------------------
# Streamlit Dashboard UI
# ---------------------------
st.set_page_config(page_title="Sales Dashboard", layout="wide")

st.title("📊 Interactive Sales Dashboard")
st.markdown("A colorful and interactive dashboard built with **Streamlit + Fake Data**.")

# Sidebar Filters
st.sidebar.header("🔍 Filter Options")
store_filter = st.sidebar.multiselect("Select Store(s):", options=stores, default=stores)
product_filter = st.sidebar.multiselect("Select Product(s):", options=products, default=products)

filtered_df = df[(df["Store"].isin(store_filter)) & (df["Product"].isin(product_filter))]

# ---------------------------
# Charts
# ---------------------------
col1, col2 = st.columns(2)

with col1:
    st.subheader("📈 Sales Trend Over Time")
    fig_line = px.line(filtered_df, x="Date", y="Sales", color="Store", markers=True,
                       title="Monthly Sales Trend")
    st.plotly_chart(fig_line, use_container_width=True)

with col2:
    st.subheader("🏬 Sales by Product Category")
    fig_bar = px.bar(filtered_df, x="Product", y="Sales", color="Product", barmode="group",
                     title="Product-wise Sales", text_auto=True)
    st.plotly_chart(fig_bar, use_container_width=True)

# Pie Chart
st.subheader("🍩 Store Contribution to Sales")
fig_pie = px.pie(filtered_df, names="Store", values="Sales", hole=0.4,
                 color_discrete_sequence=px.colors.sequential.RdBu)
st.plotly_chart(fig_pie, use_container_width=True)

# ---------------------------
# Data Table
# ---------------------------
st.subheader("📋 Filtered Sales Data")
st.dataframe(filtered_df.reset_index(drop=True))
