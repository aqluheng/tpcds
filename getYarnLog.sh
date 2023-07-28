# baseIdx=336
# outDir="yarn_gluten"
baseIdx=433
outDir="yarn_disHashJoin"

for ((i=93; i<=99; i++))
do
nowIdx=$((i+baseIdx))
yarn logs -applicationId application_1688976280613_0$nowIdx &> ${outDir}/q${i}.log
done