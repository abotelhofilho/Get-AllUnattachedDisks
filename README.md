# Get-AllUnattachedDisks
Powershell function to export a list of all unattached azure disk on ALL Azure subscription

You can also just go to Azure Advisor and check for under cost for the "You have disks that are not attached to a VM . Please evaluate if you still need the disk." advisory


## Usage

- **Clone repo**
    ```sh
    git clone https://github.com/abotelhofilho/Get-AllUnattachedDisks
    cd .\Get-AllUnattachedDisks\
    ```

- **dot load it into your powershell session**
    ```sh
    . .\func_Get-AllUnattachedDisks.ps1
    ```

- **Run the function**
    ```sh
    Get-AllunattachedDisks -Export_CSV_path c:\tmp
    ```

