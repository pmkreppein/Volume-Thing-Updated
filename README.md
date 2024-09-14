# Volume-Thing-Updated

These 3 scripts are designed to be a "volume lighthouse" for optionable symbols traded on public US markets. 

DownloadAV reads the (out of date) file named CBOE_FILE, a CSV file freely available from the Chicago Board Options Exchange website at cboe.com.  For each symbol listed in that file, the script will download two months of OHLCV (Open, high, low, close, volume) for thr given symbol.  This generates approximately 4000 files of 2 month market history, or however many symbols you have in the CBOE file. 

MakeCurves takes the two months of market history and summarizes them into one file. Meaning, for each symbol, you will have a file that lists the average volume of shares traded up to that time over the past two months.  This script no longer works and will require fixing. 

The third file would theoretically compare the current volume to the average over the past few months. 

The end goal of this effort was to be able to spot potential big market moves before they occurred. 

Overall, the quality of this scripting is low, but I did have it working a few times successfully.  

**Investing involves risk.  Carefully read and understand all financial instrument documentation before investing.  This is not an offer to sell securities.  

**This software is released without warrenty. Use at own risk. 
