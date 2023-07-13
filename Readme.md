# Daily Data Cleanup Script

The Daily Data Cleanup Script is a Bash script designed to run as a scheduled task and delete data from specified tables in a MySQL database. It helps to manage the size of the tables by removing older records on a daily basis.

## Requirements

- Bash shell
- MySQL command-line tool (MySQL client) installed and accessible from the command line
- Appropriate permissions to connect to the MySQL database and execute the SQL queries

## Configuration

1. Open the script file `cleanup_script.sh` in a text editor.
2. Set the MySQL credentials by modifying the `DB_USER` and `DB_PASS` variables with your MySQL username and password, respectively.
3. Set the name of the database by modifying the `DB_NAME` variable.
4. Adjust the `DAYS_TO_KEEP` variable to specify the number of days of data to retain in the tables.

## Usage

1. Save the script file `cleanup_script.sh` to a desired location on your system.
2. Open a terminal and navigate to the directory where the script is saved.
3. Make the script file executable by running the following command:

chmod +x cleanup_script.sh

4. Test the script by running it manually:
   
./cleanup_script.sh

The script will execute the SQL queries and display the progress and results in the terminal.
5. Schedule the script as a daily cron job by editing your crontab file:

crontab -e

Add the following line to the crontab file to run the script at midnight (00:00) every day:

0 0 * * * /path/to/cleanup_script.sh


Adjust the `/path/to/cleanup_script.sh` with the actual path where you saved the script file.

## Notes

- This script assumes that the MySQL command-line tool (`mysql`) is installed and accessible from the command line. If it's not in the system's PATH, you may need to provide the full path to the `mysql` command in the script.
- It's important to ensure that the MySQL user specified in the script has the necessary privileges to connect to the database and execute the delete queries.
- Take caution when scheduling the script to run as a cron job. Make sure it's running at an appropriate time and won't conflict with other database operations or backups.
- Monitor the script execution and check the script's output, including any error messages, to ensure it's working correctly.

## License

This script is provided under the [MIT License](LICENSE).
