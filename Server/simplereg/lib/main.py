import requests
from html.parser import HTMLParser
import json
import sys
import sqlite3
import os

companies = ["SBI"]


def SBIBeh(surname, number, url, action):
    class MyHTMLParser(HTMLParser):
        dest = ""
        meth = ""
        params = {}
        inform = False

        def handle_starttag(self, tag, attrs):
            if tag == "form":
                self.inform = True
                for attr in attrs:
                    if attr[0] == "action":
                        self.dest = attr[1]
                    elif attr[0] == "method":
                        self.meth = attr[1]
            # elif tag == "input" and self.inform:
            #     for attr in attrs:
            #         if attr[0] == "name":
            #             self.params[attr[1]] = ""

        def handle_endtag(self, tag):
            if tag == "form":
                self.inform = False

    class ResponseParser(HTMLParser):
        inmes = False
        handle = False
        respon = ""
        def handle_starttag(self, tag, attrs):
            if tag == "ul":
                for attr in attrs:
                    if attr[0] == "class" and attr[1] == "errorMessage":
                        self.inmes = True
            if tag == "li" and self.inmes:
                self.handle = True

        def handle_endtag(self, tag):
            if tag == "li" and self.handle:
                self.handle = False
            if tag == "ul" and self.inmes:
                self.inmes = False

        def handle_data(self, data):
            if self.handle:
                self.respon = data

    parser = MyHTMLParser()
    s = requests.Session()
    parser.feed(s.get(url + action).text)
    parser.params["surname"] = surname
    parser.params["number"] = number
    r = s.post(url + parser.dest, data=parser.params)
    #s.get("https://www.s7.ru/ru/online_services/onterminal.dot")
    # r = s.get("https://www.s7.ru/ru/online_services/onterminal.dot")
    # print(r.encoding)
    # print(r.url)
    # for i in s.cookies:
    #     print(i)
    # with open("qeq.html", "w+", encoding="utf-8") as f:
    #     f.write(r.text)
    resparser = ResponseParser()
    resparser.feed(r.text)
    return json.dumps({"error": resparser.respon})


def UralBeh(surname, number, url, action):
    class MyHTMLParser(HTMLParser):
        dest = ""
        meth = ""
        params = {}
        inform = False

        def handle_starttag(self, tag, attrs):
            if tag == "form":
                self.inform = True
                for attr in attrs:
                    if attr[0] == "action":
                        self.dest = attr[1]
                    elif attr[0] == "method":
                        self.meth = attr[1]
            # elif tag == "input" and self.inform:
            #     for attr in attrs:
            #         if attr[0] == "name":
            #             self.params[attr[1]] = ""

        def handle_endtag(self, tag):
            if tag == "form":
                self.inform = False

    class ResponseParser(HTMLParser):
        inmes = False
        handle = False
        respon = ""

        def handle_starttag(self, tag, attrs):
            if tag == "div":
                for attr in attrs:
                    if attr[0] == "class" and "error" in attr[1].split(" "):
                        self.inmes = True
            if tag == "div" and self.inmes:
                for attr in attrs:
                    if attr[0] == "class" and "dialog-show-message" in attr[1].split(" "):
                        self.handle = True

        def handle_endtag(self, tag):
            if tag == "div" and self.handle and self.inmes:
                self.handle = False
                self.inmes = False

        def handle_data(self, data):
            if self.handle:
                self.respon = data

    parser = MyHTMLParser()
    s = requests.Session()
    parser.feed(s.get(url + action).text)
    parser.params["lastname"] = surname
    parser.params["ticket"] = number
    r = s.post(url + parser.dest, data=parser.params)
    #s.get("https://www.s7.ru/ru/online_services/onterminal.dot")
    # r = s.get("https://www.s7.ru/ru/online_services/onterminal.dot")
    # print(r.encoding)
    # print(r.url)
    # for i in s.cookies:
    #     print(i)
    with open("qeq.html", "w+", encoding="utf-8") as f:
        f.write(r.text)
    resparser = ResponseParser()
    resparser.feed(r.text)
    return json.dumps({"error": resparser.respon})

#urls = {"SBI": ("https://webcheckin.s7.ru", "/login.action", SBIBeh)}

if __name__ == '__main__':
    with open(sys.argv[1], "r") as f:
        inp = json.loads(f.readline())
    os.remove(sys.argv[1])
    conn = sqlite3.connect("companies.db")
    cursor = conn.cursor()
    sql = """SELECT * FROM companies WHERE company_id = '""" + inp["aircompanyId"] + """';"""
    cursor.execute(sql)
    #print(cursor.fetchall()[0])
    response = cursor.fetchall()[0]
    locals()[response[4]](inp["surname"], inp["registrationNumber"], response[2], response[3])
    #urls[inp["aircompanyId"]][2](inp["surname"], inp["registrationNumber"])
    conn.close()