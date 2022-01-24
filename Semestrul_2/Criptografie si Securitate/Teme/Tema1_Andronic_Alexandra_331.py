def otp(mesaj, chei):
    # pentru fiecare cheie din lista de chei
    for k in chei:
        # pentru fiecare cheie trebuie sa adaug cheia de atatea ori la lungimea sa pentru a fi egala cu lungimea mesajului
        cheie_repetata = k
        # vad ce lungime are mesajul
        lg_mesaj = len(mesaj)
        # vad de cate ori se imparte la 4
        lg_secvente = lg_mesaj // 4
        # si adaug acea secventa de atatea ori la mesaj
        for lg in range(lg_secvente):
            cheie_repetata += k
        # daca cumva lungimea mesajului nu este divizibila cu 4
        # trebuie sa mai adaug la sfarsit o parte din cheie
        rest_secventa = lg_mesaj % 4
        for lg in range(rest_secventa):
            cheie_repetata += k[lg]
        # variabila in care salvez mesajul decriptat
        # acum trebuie sa fac XOR intre caracterele mesajului si cele din cheie
        mesaj_dec = ""
        for j in range(lg_mesaj):
            mesaj_dec += format(int(mesaj[j], 16) ^ int(cheie_repetata[j], 16), 'x')

        
        # trebuie sa transform mesajele din hexa in ascii
        # print(mesaj_dec)
        mesaj_dec_ascii = ""
        for i in range(len(mesaj) // 2):
            caracter = int(mesaj_dec[2 * i : 2 * (i + 1)], 16)
            if caracter == 0:
                mesaj_dec_ascii += " "
            else:
                mesaj_dec_ascii += chr(caracter)

        f.write(f"Pentru cheia {k} avem mesajul {mesaj_dec_ascii}")
        f.write("\n")
       

if __name__ == '__main__':
    # mesajul de criptat
    f = open("mesaje_decodate.txt", "w", encoding="UTF-8")
    mesaj = "3CC85DD318D40EC809810EC05DC518C20FC80DD518DB148110C40EC017D411"
    # generez toate cele 65536 de chei hexa
    simboluri_hexa = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
    lista_chei = [a + b + c + d for a in simboluri_hexa for b in simboluri_hexa for c in simboluri_hexa for d in simboluri_hexa]
    print(f"Lungimea vectorului de chei este {len(lista_chei)}")
    otp(mesaj, lista_chei)
    
