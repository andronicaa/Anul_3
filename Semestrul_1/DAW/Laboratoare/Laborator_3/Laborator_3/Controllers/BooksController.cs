using Laborator_3.DataAccessLayer;
using Laborator_3.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace Laborator_3.Controllers
{
    [RoutePrefix("books")]
    public class BooksController : Controller
    {
        // pentru a accesa in mod concret baza de date dintr-un controller
        // vom introduce in blocul controllerului un obiect privat din clasa context
        private DbCtx ctx = new DbCtx();
        // GET: Books
        [Route("")]
        public ActionResult Index()
        {
            List<Book> books = ctx.Books.ToList();
            return View(books);
        }

        [Route("cauta/{id:regex(^[0-9]+$)}")]
        public ActionResult Cauta(int id)
        {
            Book book = ctx.Books.Find(id);
            return View(book);
        }
        /*
        [Route("new")]
        public ActionResult New()
        {
            Book book = new Book();
            return View(book);
        }

        [HttpPost]
        public ActionResult Create(Book b)
        {
            db.Books.Add(b);
            db.SaveChanges();
            return RedirectToAction("Index", "Books");
        }

        [Route("edit/{id}")]
        public ActionResult Edit(int id)
        {
            Book book = db.Books.Find(id);
            return View(book);
        }

        [HttpPost]
        public ActionResult Update(Book b)
        {
            Book book = db.Books.Single(s => s.BookId == b.BookId);
            book.Title = b.Title;
            book.Author = b.Author;
            db.SaveChanges();
            return RedirectToAction("Index", "Books");
        }

        [Route("delete/{id}")]
        public ActionResult Delete(int id)
        {
            Book book = db.Books.Find(id);
            db.Books.Remove(book);
            db.SaveChanges();
            return RedirectToAction("Index", "Books");
        }*/
    }
}