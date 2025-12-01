CREATE OR REPLACE TABLE 
  `rakamin-kf-analytics-479503.kimia_farma.tabel_analisa` AS

WITH transaksi AS (
  SELECT
      tr.*,
      p.product_name,
      kc.branch_name,
      kc.kota,
      kc.provinsi,
      kc.rating AS rating_cabang,

      CASE
          WHEN tr.price <= 50000 THEN 0.10
          WHEN tr.price <= 100000 THEN 0.15
          WHEN tr.price <= 300000 THEN 0.20
          WHEN tr.price <= 500000 THEN 0.25
          ELSE 0.30
      END AS persentase_gross_laba

  FROM
      `rakamin-kf-analytics-479503.kimia_farma.kf_final_transaction` tr
  LEFT JOIN
      `rakamin-kf-analytics-479503.kimia_farma.kf_product` p
  ON tr.product_id = p.product_id
  LEFT JOIN
      `rakamin-kf-analytics-479503.kimia_farma.kf_kantor_cabang` kc
  ON tr.branch_id = kc.branch_id
)

SELECT
    transaction_id,
    date,
    branch_id,
    branch_name,
    kota,
    provinsi,
    rating_cabang,
    customer_name,
    product_id,
    product_name,
    price AS actual_price,
    discount_percentage,
    persentase_gross_laba,

    -- nett_sales
    price * (1 - discount_percentage/100) AS nett_sales,

    -- nett_profit = nett_sales * persentase_gross_laba
    (price * (1 - discount_percentage/100)) * persentase_gross_laba AS nett_profit,

    rating AS rating_transaksi
FROM transaksi;