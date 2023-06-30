#!/bin/bash
rm -f ./nmonFile/*
sudo -u emr-user scp -r -o StrictHostKeyChecking=no core-1-1:/home/emr-user/query*.nmon ./nmonFile/

for file in ./nmonFile/*.nmon; do
    if [ -f "$file" ]; then
        echo $file
        ./nmonchart-master/nmonchart $file
    fi
done

old_names=("query1.html" "query2.html" "query3.html" "query4.html" "query5.html" "query6.html" "query7.html" "query8.html" "query9.html" "query10.html" "query11.html" "query12.html" "query13.html" "query14.html" "query15.html" "query16.html" "query17.html" "query18.html" "query19.html" "query20.html" "query21.html" "query22.html" "query23.html" "query24.html" "query25.html" "query26.html" "query27.html" "query28.html" "query29.html" "query30.html" "query31.html" "query32.html" "query33.html" "query34.html" "query35.html" "query36.html" "query37.html" "query38.html" "query39.html" "query40.html" "query41.html" "query42.html" "query43.html" "query44.html" "query45.html" "query46.html" "query47.html" "query48.html" "query49.html" "query50.html" "query51.html" "query52.html" "query53.html" "query54.html" "query55.html" "query56.html" "query57.html" "query58.html" "query59.html" "query60.html" "query61.html" "query62.html" "query63.html" "query64.html" "query65.html" "query66.html" "query67.html" "query68.html" "query69.html" "query70.html" "query71.html" "query72.html" "query73.html" "query74.html" "query75.html" "query76.html" "query77.html" "query78.html" "query79.html" "query80.html" "query81.html" "query82.html" "query83.html" "query84.html" "query85.html" "query86.html" "query87.html" "query88.html" "query89.html" "query90.html" "query91.html" "query92.html" "query93.html" "query94.html" "query95.html" "query96.html" "query97.html" "query98.html" "query99.html" "query100.html" "query101.html" "query102.html" "query103.html")

new_names=("q1" "q2" "q3" "q4" "q5" "q6" "q7" "q8" "q9" "q10" "q11" "q12" "q13" "q14a" "q14b" "q15" "q16" "q17" "q18" "q19" "q20" "q21" "q22" "q23a" "q23b" "q24a" "q24b" "q25" "q26" "q27" "q28" "q29" "q30" "q31" "q32" "q33" "q34" "q35" "q36" "q37" "q38" "q39a" "q39b" "q40" "q41" "q42" "q43" "q44" "q45" "q46" "q47" "q48" "q49" "q50" "q51" "q52" "q53" "q54" "q55" "q56" "q57" "q58" "q59" "q60" "q61" "q62" "q63" "q64" "q65" "q66" "q67" "q68" "q69" "q70" "q71" "q72" "q73" "q74" "q75" "q76" "q77" "q78" "q79" "q80" "q81" "q82" "q83" "q84" "q85" "q86" "q87" "q88" "q89" "q90" "q91" "q92" "q93" "q94" "q95" "q96" "q97" "q98" "q99" )

directory=./nmonFile/
for ((i=0; i<${#old_names[@]}; i++)); do
    old_file="${directory}${old_names[$i]}"
    new_file="${directory}${new_names[$i]}.html"

    # 检查旧文件是否存在
    if [ -f "$old_file" ]; then
        mv -n "$old_file" "$new_file"
        echo "Renamed $old_file to $new_file"
    fi
done

tar -cf nmonHtml.tar ./nmonFile/*.html

