require 'playwright'

Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
  playwright.chromium.launch(headless: false) do |browser|
    page = browser.new_page
    page.goto('https://github.com/search/advanced')

    search_input = page.query_selector('input[aria-labelledby="search-title"]')
    search_input.click
    page.keyboard.type("playwright")
    page.expect_navigation {
      page.keyboard.press("Enter")
    }

    list = page.query_selector('div[data-testid="results-list"]')
    items = list.query_selector_all("div.search-title")
    items.each do |item|
      title = item.eval_on_selector("a", "a => a.innerText")
      puts("==> #{title}")
    end
  end
end