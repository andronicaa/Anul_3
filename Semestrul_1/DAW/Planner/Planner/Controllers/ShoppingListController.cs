using Planner.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    public class ShoppingListController : Controller
    {
        private ApplicationDbContext ctx = new ApplicationDbContext();
        // GET: ShoppingList
        public ActionResult Index()
        {
            var lists = ctx.ShoppingLists.Include("Products");
            ViewBag.Lists = lists;
            return View();
        }
        [Route("ShoppingList/details/{id}")]
        public ActionResult Details(int? id)
        {
            if (id.HasValue)
            {
                // caut lista cu detaliile respective
                
                ShoppingList list = ctx.ShoppingLists.Include("Products").Where(p => p.ShoppingListId == id).FirstOrDefault();
                
                if (list != null)
                {
                    return View(list);
                }
                return HttpNotFound("Nu exista cartea cu acest id");
            }
            return HttpNotFound("Nu s-a dat parametrul id");
        }

        [Route("ShoppingList/newlist")]
        public ActionResult NewList()
        {
            ShoppingList list = new ShoppingList();
            return View(list);
        }

        [HttpPost]
        public ActionResult CreateList(ShoppingList list)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ctx.ShoppingLists.Add(list);
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "ShoppingList");
                }
                return View("NewList", list);
            } catch(Exception e)
            {
                return View("NewList", list);
            }
            
            
            
        }

        [Route("ShoppingList/editlist/{id}")]
        public ActionResult EditList(int id)
        {
            // gasesc lista in baza de date
            ShoppingList listById = ctx.ShoppingLists.Find(id);
            return View(listById);
        }

        [HttpPost]
        public ActionResult UpdateList(int id, ShoppingList sl)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // caut lista de cumparaturi in baza de date
                    ShoppingList list = ctx.ShoppingLists.Find(id);
                    list.Titlu = sl.Titlu;
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "ShoppingList");
                }
                return View("EditList/" + id, sl);
            } catch(Exception e)
            {
                return View("EditList/" + id, sl);
            }
        }

        [HttpPost]
        
        public ActionResult DeleteList(int id)
        {
            // daca se sterge o lista => nu trebuie sa se stearga si toate produsele ce se afla in ea
            ShoppingList list = ctx.ShoppingLists.Find(id);
            if (list == null)
            {
                return HttpNotFound("Nu exista lista cu id-ul dat");
            }
            ctx.ShoppingLists.Remove(list);
            ctx.SaveChanges();
            return RedirectToAction("Index", "ShoppingList");
        }
        

    }
}