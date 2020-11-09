using Laborator_3_1.DataAccessLayer;
using Laborator_3_1.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Laborator_3_1.Controllers
{
    [RoutePrefix("books")]
    public class BookTypesController : Controller
    {
        // trebuie sa facem o instanta a bazei de date
        private MyDbCtx ctx = new MyDbCtx();
        public ActionResult Index()
        {
            List<BookType> bookTypes = ctx.BookTypes.ToList();
            return View(bookTypes);
        }
        [Route("new")]
        public ActionResult New()
        {
            BookType bookType = new BookType();
            return View(bookType);
        }

        [HttpPost]
        public ActionResult Create(BookType bt)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ctx.BookTypes.Add(bt);
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "BookTypes");
                }
                return View(bt);
            }
            catch (Exception e)
            {
                return View(bt);
            }
        }

        [Route("edit/{id?}")]
        public ActionResult Edit(int? id)
        {
            if (id.HasValue)
            {
                // cautam cartea cu id-ul corespunzator
                BookType bt = ctx.BookTypes.Find(id);

                if (bt == null)
                {
                    return HttpNotFound("Nu s-a gasit cartea cu id-ul dat");
                }
                return View(bt);
            }
            return HttpNotFound("Nu s-a gasit cartea cu id-ul...");
        }

        [HttpPut]
        public ActionResult Update(int id, BookType bt)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    BookType bookType = ctx.BookTypes.Find(id);
                    if (TryUpdateModel(bt))
                    {
                        bookType.Name = bt.Name;
                        ctx.SaveChanges();
                    }
                    return RedirectToAction("Index", "BookTypes");
                }
                return View(bt);
            }
            catch (Exception e)
            {
                return View(bt);
            }
        }
    }
}