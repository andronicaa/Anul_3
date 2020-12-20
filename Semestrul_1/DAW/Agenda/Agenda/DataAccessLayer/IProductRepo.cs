using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public interface IProductRepo
    {
        bool SaveChanges();
        // vreau sa listez toate produsele dintr-o lista cu id-ul date
        IEnumerable<Product> GetAllProducts(int id);

        // caut in baza de date un produs
        Product GetProductById(int? id);

        // adaug in baza de date un produs(care sa apartina unei liste)
        void CreateProduct(Product prs);
        
        // sterg din baza de date(dintr-o lista) un anumit produs
        void DeleteProduct(Product prs);
    }
}
