using Agenda.Data;
using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class SqlShoppingListRepo : IShoppingListRepo
    {
        private readonly ApplicationDbContext _ctx;

        // instanta a basei de date
        public SqlShoppingListRepo(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }
        public void CreateShoppingList(ShoppingList prs)
        {
            throw new NotImplementedException();
        }

        public void DeleteShoppingList(ShoppingList prs)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<ShoppingList> GetAllLists(int id)
        {
            throw new NotImplementedException();
        }

        public ShoppingList GetListById(int id)
        {
            // am un id si vreau sa gasesc in baza de date lista de cumparaturi cu id = {id} is produsele din aceasta
            return _ctx.ShoppingLists.FirstOrDefault(p => p.ShoppingListId == id);
        }

        public bool SaveChanges()
        {
            throw new NotImplementedException();
        }
    }
}
