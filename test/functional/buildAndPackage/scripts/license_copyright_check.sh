#!/bin/bash

semeru_certified_name="IBM Semeru Runtime Certified Edition"
semeru_open_name="IBM Semeru Runtime Open Edition"
is_certified_semeru=false

license_copyright_check() {
    echo "TEST_JDK_HOME is TEST_JDK_HOME"
    java_runtime_name=$($TEST_JDK_HOME/bin/java -XshowSettings:properties -version 2>&1 | grep "java.runtime.name")
    echo $java_runtime_name

    if [[ "$java_runtime_name" == *"$semeru_certified_name"* ]]; then
        is_certified_semeru=true
    elif [[ "$java_runtime_name" == *"$semeru_open_name"* ]]; then
        is_certified_semeru=false
    else
        echo "Error: JDK Name is not IBM Semeru Runtime! $java_runtime_name"
        exit 1
    fi

    error_msg_mismatch_edition="Error: Mismatch Edition!"
    pass_msg_match_edition="One Edition Match check Passed."
    
    readme_file_certified="$TEST_JDK_HOME/README.txt"
    if [[ "$is_certified_semeru" == "true" && -e "$readme_file_certified" ]]; then
        echo "$pass_msg_match_edition $readme_file_certified."
    elif [[ "$is_certified_semeru" == "false" && ! -e "$readme_file_certified" ]]; then
        echo "$pass_msg_match_edition $readme_file_certified."
    else
        echo "$error_msg_mismatch_edition $readme_file_certified."
        exit 1
    fi

    legal_folder="$TEST_JDK_HOME/legal"
    files_in_license_folder_in_legal_folder_certified=("license_cs.txt" "license_it.txt" "license_sl.txt" "license_de.txt" "license_ja.txt" 
        "license_tr.txt" "license_el.txt" "license_ko.txt" "license_zh.txt" "license_en.txt" "license_lt.txt" "license_zh_TW.txt" "license_es.txt" 
        "license_pl.txt" "notices.txt" "license_fr.txt" "license_pt.txt" "license_in.txt" "license_ru.txt")
    files_in_legal_folder_open=("LICENSE" "ADDITIONAL_LICENSE_INFO" "ASSEMBLY_EXCEPTION")


    for subfolder_in_legal in $legal_folder/*
    do
        copyright_in_legal_folder_certified="$subfolder_in_legal/Copyright"
        if [[ "$is_certified_semeru" == "true" && -e "$copyright_in_legal_folder_certified" ]]; then
            echo "$pass_msg_match_edition $copyright_in_legal_folder_certified."
        elif [[ "$is_certified_semeru" == "false" && ! -e "$copyright_in_legal_folder_certified" ]]; then
            echo "$pass_msg_match_edition $copyright_in_legal_folder_certified."
        else
            echo "$error_msg_mismatch_edition $copyright_in_legal_folder_certified."
            exit 1
        fi

        license_folder_in_legal_folder_certified="$subfolder_in_legal/license/"
        if [[ "$is_certified_semeru" == "true" && -d $license_folder_in_legal_folder_certified ]]; then
            files_in_license_folder_in_legal_folder_certified=("license_cs.txt" "license_it.txt" "license_sl.txt" "license_de.txt" "license_ja.txt" 
                "license_tr.txt" "license_el.txt" "license_ko.txt" "license_zh.txt" "license_en.txt" "license_lt.txt" "license_zh_TW.txt" "license_es.txt" 
                "license_pl.txt" "notices.txt" "license_fr.txt" "license_pt.txt" "license_in.txt" "license_ru.txt")
            for license_language_file_certified_local in "${files_in_license_folder_in_legal_folder_certified[@]}"
            do
                license_language_file_certified="$license_folder_in_legal_folder_certified/$license_language_file_certified_local"
                if [[ -e $license_language_file_certified ]]; then
                    echo "$pass_msg_match_edition $license_language_file_certified."
                else
                    echo "$error_msg_mismatch_edition $license_language_file_certified."
                    exit 1
                fi
            done
        elif [[ "$is_certified_semeru" == "false" && ! -d $license_folder_in_legal_folder_certified ]]; then
            echo "$pass_msg_match_edition $license_folder_in_legal_folder_certified."
        else
            echo "$error_msg_mismatch_edition $license_folder_in_legal_folder_certified."
            exit 1
        fi

        for license_file_open in "${files_in_legal_folder_open[@]}"
        do
            if [[ "$is_certified_semeru" == "true" && ! -f "$subfolder_in_legal/$license_file_open" ]]; then
                echo "$pass_msg_match_edition $subfolder_in_legal/$license_file_open."
            elif  [[ "$is_certified_semeru" == "false" && -f "$subfolder_in_legal/$license_file_open" ]]; then
                echo "$pass_msg_match_edition $subfolder_in_legal/$license_file_open."
            else
                echo "$error_msg_mismatch_edition $subfolder_in_legal/$license_file_open."
                exit 1
            fi
        done
    done

    echo "PASSED ALL License and Copyright file check!"
}

license_copyright_check
