using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace ConversaoPeso.Web.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }
        
        [HttpPost]
        public IActionResult Index(string selectTemp, decimal valorRef)
        {
            if (selectTemp.Equals("1"))
            {
                ViewData["unidade"] = "quilo";
                ViewData["valor"] = valorRef / 1000;
            }
            else
            {
                ViewData["unidade"] = "grama";
                ViewData["valor"] = valorRef * 1000;
            }

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }
        
    }
}
