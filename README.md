# Adding Data to the Data Package

1. Get the 'CodeClanData' repo from CodeClan's GitHub.

2. Go to the file `data_raw/prep_data.R`.

3. Define your dataset in this file. This can be as simple as reading a CSV file (put raw files in `data_raw/data`), or you might want to do a lot of cleaning or API calls. You can see some examples in this folder. You can store raw data files in the data folder inside data-raw. 

*Note: we can't use files greater than 100MB on GitHub*
*Note: try to put the code in the correct place alphabetically so it's easy to find later.*

4. Once you've created your dataset, add a `use_data` function for your chosen data (see examples at the end of `prep_data.R`). 

5. Run the whole of `prep_data.R`.

6. Now go to `R/documentation.R`. Here you write a short description of your dataset, which will be shown in the documentation. See examples from the other datasets. 

7. Use `devtools::document()` in the console.

8. Push changes to GitHub. 

9. Reinstall the package on your machine using `devtools::install_github('codeclan/CodeClanData')`
