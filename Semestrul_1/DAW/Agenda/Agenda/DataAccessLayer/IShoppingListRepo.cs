using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public interface IShoppingListRepo
    {
        bool SaveChanges();
        IEnumerable<ShoppingList> GetAllLists(int id);
        // caut in baza de date o lista de cumparaturi(care la randul ei este compusa din mai multe produse)
        ShoppingList GetListById(int id);

        // adaug o noua lista de cumparaturi in baza de date
        void CreateShoppingList(ShoppingList prs);

        // sterg o lista de cumparaturi din baza de date si odata cu aceasta si produsele corespunzatoare ei
        void DeleteShoppingList(ShoppingList prs);
    }
}
