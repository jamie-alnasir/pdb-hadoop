
sed -n '/-----+------------+----------+----------/,/Writing output/{/-----+------------+----------+----------/b;/Writing output/b;p}' $1