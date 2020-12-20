using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class SqlProductRepo : IProductRepo
    {
        public void CreateProduct(Product prs)
        {
            throw new NotImplementedException();
        }

        public void DeleteProduct(Product prs)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Product> GetAllProducts(int id)
        {
            // caut produsele in baza de date din lista cu Id-ul = {id}
            throw new NotImplementedException();
        }

        public Product GetProductById(int? id)
        {
            throw new NotImplementedException();
        }

        public bool SaveChanges()
        {
            throw new NotImplementedException();
        }
    }
}
