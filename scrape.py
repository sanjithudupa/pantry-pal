import requests
import os
import random
from bs4 import BeautifulSoup
import json

def misspell(message):
    # convert the message to a list of characters
    message = list(message)

    typo_prob = random.uniform(0.05, 0.15)# percent (out of 1.0) of characters to become typos

    # the number of characters that will be typos
    n_chars_to_flip = round(len(message) * typo_prob)
    # is a letter capitalized?
    capitalization = [False] * len(message)
    # make all characters lowercase & record uppercase
    for i in range(len(message)):
        capitalization[i] = message[i].isupper()
        message[i] = message[i].lower()

    # list of characters that will be flipped
    pos_to_flip = []
    for i in range(n_chars_to_flip):
        pos_to_flip.append(random.randint(0, len(message) - 1))

    # dictionary... for each letter list of letters
    # nearby on the keyboard
    nearbykeys = {
        'a': ['q','w','s','x','z'],
        'b': ['v','g','h','n'],
        'c': ['x','d','f','v'],
        'd': ['s','e','r','f','c','x'],
        'e': ['w','s','d','r'],
        'f': ['d','r','t','g','v','c'],
        'g': ['f','t','y','h','b','v'],
        'h': ['g','y','u','j','n','b'],
        'i': ['u','j','k','o'],
        'j': ['h','u','i','k','n','m'],
        'k': ['j','i','o','l','m'],
        'l': ['k','o','p'],
        'm': ['n','j','k','l'],
        'n': ['b','h','j','m'],
        'o': ['i','k','l','p'],
        'p': ['o','l'],
        'q': ['w','a','s'],
        'r': ['e','d','f','t'],
        's': ['w','e','d','x','z','a'],
        't': ['r','f','g','y'],
        'u': ['y','h','j','i'],
        'v': ['c','f','g','v','b'],
        'w': ['q','a','s','e'],
        'x': ['z','s','d','c'],
        'y': ['t','g','h','u'],
        'z': ['a','s','x'],
        ' ': ['c','v','b','n','m']
    }

    # insert typos
    for pos in pos_to_flip:
        # try-except in case of special characters
        try:
            typo_arrays = nearbykeys[message[pos]]
            message[pos] = random.choice(typo_arrays)
        except:
            break

    # reinsert capitalization
    for i in range(len(message)):
        if (capitalization[i]):
            message[i] = message[i].upper()

    # recombine the message into a string
    message = ''.join(message)
    return message

def getResults(item):
    cookies = {
        'CGIC': 'CgZzYWZhcmkiP3RleHQvaHRtbCxhcHBsaWNhdGlvbi94aHRtbCt4bWwsYXBwbGljYXRpb24veG1sO3E9MC45LCovKjtxPTAuOA',
        'SIDCC': 'AJi4QfGrDvzS0ASuXTIobiRVXqwx8ZsVG1zpjYjQ9xwKvUzsZxO3ZNvqgQ91Ax5xg0ozxGH7Ciw',
        '__Secure-3PSIDCC': 'AJi4QfHq9gRKpK_yiBRL-njNvOzk0A8X61PLxEyUsIdriAwPKWf5vREAFevIhGkbARsOXnW9i0w',
        '1P_JAR': '2021-08-15-21',
        'DV': 'E2TWB5KCzjhU8Np-rLIiKFcESzS9tNdIVOFZOLg67QAAAADRB9mqW1MGwQAAAKTFK4G1nWhITwAAAIiwmD0DUaRDKdEHAA',
        'NID': '221=bapgBY3cbzQUOxUf3UBRZVSSu9gmEWQJ9fMzBRkT5YLh_F_uVd50Uo14Hd6Evz_whCA5O5udvOoXnQ1iMwH2fbX0EyO05FN9uuC8pkQM-uWYTSjnKTl3pFhljCBsMacJx4--6C57MhkpFpPpmpX9j291JoFdeMNj_Dm08hpSahlq6ojBai1QmhzJZqvtWlUcUb9JRu72IcrjoqaR1PtIz4coT87zJHuUtbq73MdnBV8h3GmhGHrksaHY6wBpllC1Sy6v2C9qR6mwsdZF9F7q93gOp6NKSI0WtAvSq_AdTz2vXPhpX6rA0_UNjifiosjeYndfV-jbQooiiqFFnTAGS0OEbNxCjdxEVW7eWc_tRL6ru9etNbIia-3hDIRJM2eZbCj5HoEwX_mcEdAbqnrGmyQpYdnLFCVDt8CQambP2OBa',
        '__Secure-1PSID': 'AQhnjGKqI5GccRCRGKztCDDQCAFEh6eBvdv7zXJuXYKKOYK96di6tKfPJvOyAK6vQbV6Dw.',
        'SID': 'AQhnjGKqI5GccRCRGKztCDDQCAFEh6eBvdv7zXJuXYKKOYK9XEywZ0QDwPoBmHCRzyrvRg.',
        '__Secure-3PSID': 'AQhnjGKqI5GccRCRGKztCDDQCAFEh6eBvdv7zXJuXYKKOYK9ckHV89P988GjQZGF5-JBSQ.',
        'APISID': 'q3R6ewDQtFN9UsHW/A6fUVexGG0TcoTA63',
        'HSID': 'AODjVniRXlHufYfkH',
        'SAPISID': 'CAVtxRKBG2X870Jr/AHm8i73jyovELZgAH',
        'SSID': 'AymKXz1LFTdpbRO8k',
        '__Secure-1PAPISID': 'CAVtxRKBG2X870Jr/AHm8i73jyovELZgAH',
        '__Secure-3PAPISID': 'CAVtxRKBG2X870Jr/AHm8i73jyovELZgAH',
        'SEARCH_SAMESITE': 'CgQI3pIB',
        'ANID': 'AHWqTUnM7Cdbul2Cey4B1AjLHUG55VHt98u1yQnCkN4XnYPYKA0YValHCnBCSVSq',
        'CONSENT': 'YES+US.en+20180617-14-0',
    }

    headers = {
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate, br',
        'Host': 'www.google.com',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15',
        'Accept-Language': 'en-us',
        'Referer': 'https://www.google.com/',
        'Connection': 'keep-alive',
    }

    params = (
        ('q', item),
        ('client', 'safari'),
        ('rls', 'en'),
        ('sxsrf', 'ALeKk01JIUGC2_j6_vgH1xUkfCA9_Tg-zA:1629064740869'),
        ('source', 'lnms'),
        ('tbm', 'shop'),
        ('sa', 'X'),
        ('ved', '2ahUKEwim3MeJg7TyAhVPHs0KHYs3AJwQ_AUoAXoECAEQAw'),
        ('biw', '1460'),
        ('bih', '756'),
    )

    page = requests.get('https://www.google.com/search', headers=headers, params=params, cookies=cookies)

    soup = BeautifulSoup(page.content, "html.parser")
    items = soup.find_all(class_="Xjkr3b")

    outputs = []
    for item in items:
        name = item.text.split("-")[0].strip()
        outputs.append(name)
        for i in range(random.randint(0, 3)):
            outputs.append(misspell(name))
    return list(set(outputs))

# print(getResults("milk"))

DATASET_HOME = "/Users/sanjithudupa/Downloads/GroceryStoreDataset-master"
DATASET_FOLDER = DATASET_HOME + "/dataset/train"
DATASET_TEXT = DATASET_HOME + "/textTrain"

classes = os.listdir(DATASET_FOLDER)

output = []

if not os.path.exists(DATASET_TEXT):
    os.mkdir(DATASET_TEXT)

for classname in classes:
    options = getResults(classname)
    index = 0

    classFolder = os.path.join(DATASET_TEXT, classname)

    if not os.path.exists(classFolder):
        os.mkdir(classFolder)

    for option in options:
        with open(os.path.join(classFolder, str(index) + "option.txt"), "w") as file:
            file.write(option)
        index += 1 

    print(classname)

