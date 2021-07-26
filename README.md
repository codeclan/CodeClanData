# Adding Data to the Data Package

1. Get the 'CodeClanData' repo from CodeClan's GitHub.

2. Go to the file `prep_data.R` inside `data-raw`. 

3. Define your dataset in this file. This can be as simple as reading a CSV file, or you might want to do a lot of cleaning or API calls. You can see some examples in this folder. You can store raw data files in the data folder inside data-raw. 

*Note: we can't use files greater than 100MB on GitHub*

4. Once you've created your dataset, run the function `use_data` with your chosen data (see examples at the end of `prep_data.R`). 

5. Now go to `documentation.R` in the R folder. Here you write a short description of your dataset, which will be shown in the documentation. See examples from the other datasets. 

6. Use `devtools::document()` in the console.

7. Push changes to GitHub. 

8. Reinstall the package on your machine using `devtools::install_github('codeclan/CodeClanData')`
