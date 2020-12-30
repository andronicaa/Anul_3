using Planner.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    [Authorize]
    public class ProductsController : Controller
    {
        private ApplicationDbContext ctx = new ApplicationDbContext();
        // GET: Products
        public ActionResult Index()
        {
            // vreau sa afisez toate produsele din toate listele de cumparaturi
            IEnumerable<Product> products = ctx.Products.ToList();
            return View(products);
        }
        public ActionResult DetaliiProdus(int id)
        {
            Product prd = ctx.Products.Find(id);
            return View(prd);
        }

        [Authorize(Roles = "Admin,Child")]
        public ActionResult EditProdus(int id)
        {
            // dupa ce afisez lista cu toate produsele din toate listele de cumparaturi, 
            // pot actualiza un singur produs ca acesta sa se actualizeze in toate listele din care face parte
            // caut produsul in baza de date
            Product prd = ctx.Products.Find(id);
            return View(prd);
        }

        [HttpPost]
        public ActionResult UpdateProdus(int id, Product prd)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // caut produsul cu id-ul gasit
                    Product produs = ctx.Products.Find(id);
                    produs.Cantitate = prd.Cantitate;
                    produs.Denumire = prd.Denumire;
                    produs.Descriere = prd.Descriere;
                    produs.Necesitate = prd.Necesitate;
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "Products");
                }
                return View("EditProdus/" + id, prd);
            } catch (Exception e)
            {
                return View("EditProdus/" + id, prd);
            }

        }

        // doar adminul poate sa sterga o produs din baza de date
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public ActionResult DeleteProdus(int id)
        {
            // caut produsul
            Product prd = ctx.Products.Find(id);
            if (prd == null)
            {
                return HttpNotFound();
            }
            // in stergem din baza de date
            ctx.Products.Remove(prd);
            // salvez modificarile
            ctx.SaveChanges();
            return RedirectToAction("Index", "Products");
        }

        
        [Authorize(Roles = "Admin, Child")]
        [Route("products/newproduct")]
        public ActionResult NewProduct()
        {
            Product prd = new Product();
            return View(prd);
        }

        [HttpPost]
        public ActionResult CreateProduct(Product prd)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ctx.Products.Add(prd);
                    ctx.SaveChanges();

                    return RedirectToAction("Index", "Products");
                }
                return View("NewProduct", prd);
            } catch(Exception e)
            {
                return View("NewPerson", prd);
                    
            }
        }


        

       
    }
}