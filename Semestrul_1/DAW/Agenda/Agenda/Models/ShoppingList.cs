using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class ShoppingList
    {
        public int ShoppingListId { get; set; }
        public string Titlu { get; set; }

        // o lista de cumparaturi poate sa aiba mai multe produse si un produs poate sa apartina mai multor liste


    }
}
