﻿using Planner.Models;
using Planner.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    [Authorize]
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

        // doar adminul poate sa faca o noua lista de cumparaturi
        [Route("ShoppingList/newlist")]
        [Authorize(Roles = "Admin")]
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


        // doar adminul poate sa editeze lista de cumparaturi(consta doar in modificarea numelui)
        [Authorize(Roles = "Admin")]
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


        // doar adminul poate sa stearga o lista de cumparaturi din baza de date
        [Authorize(Roles = "Admin")]
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


        public ActionResult AddProductInList(int id)
        {
            // id => id-ul listei curente
            // caut lista in baza de date
            ShoppingList list = ctx.ShoppingLists.Find(id);

            ShoppingListViewModel slVm = new ShoppingListViewModel();
            slVm.ShoppingListId = list.ShoppingListId;
            slVm.ShoppingProducts = GetAllProducts();
            slVm.Titlu = list.Titlu;
            return View(slVm);
        }

        [HttpPost]
        public ActionResult AddProduct(int id, ShoppingListViewModel list)
        {
            // caut in baza de date lista de cumparaturi corespunzatoare
            ShoppingList lst = ctx.ShoppingLists.Find(id);
            lst.Products = (ICollection<Product>)list.ShoppingProducts;
            return RedirectToAction("Index", "ShoppingList");
        }


        // metoda prin care iau toate produsele din baza de date sub forma de lista dropdown
        [NonAction]
        public IEnumerable<SelectListItem> GetAllProducts()
        {
            // generez o lista goala
            var selectList = new List<SelectListItem>();
            foreach (var prd in ctx.Products.ToList())
            {
                // adaugam in lista de produse(dropdown)
                selectList.Add(new SelectListItem
                {
                    Value = prd.ProductId.ToString(),
                    Text = prd.Denumire
                });
            }

            return selectList;
                 
        }
        

    }
}