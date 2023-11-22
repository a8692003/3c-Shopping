import React, { useState, useEffect } from 'react'
// import React from 'react';
import cambuyLogo from '../../assets/img/logo/cambuyLogo.png'
import searchIcon from '../../assets/img/icons/search.png'
import adviceIcon from '../../assets/img/icons/advice.png'
import memberIcon from '../../assets/img/icons/member.png'
import cartIcon from '../../assets/img/icons/buy-cart.png'

const Head = () => {
  const [isDarkMode, setIsDarkMode] = useState(false)

  useEffect(() => {
    if (isDarkMode) {
      document.body.classList.add('dark-mode')
    } else {
      document.body.classList.remove('dark-mode')
    }
  }, [isDarkMode])

  return (
    <header>
      <nav className="header">
        <ul>
          <li>
            <a href="http://localhost:2407/" title="回首頁">
              <img src={cambuyLogo} alt="cambuyLogo" />
            </a>
          </li>
          <li>
            <form action="/search" method="get">
              <input type="text" name="search" placeholder="search" />
              <button type="submit" title="搜尋">
                <img src={searchIcon} alt="search" />
              </button>
            </form>
          </li>

          <li>
            <label className="switch">
              <input
                type="checkbox"
                checked={isDarkMode}
                onChange={() => setIsDarkMode(!isDarkMode)}
              />
              <span className="slider round">
                <span className="sun">☼</span>
                <span className="moon">☽</span>
              </span>
            </label>
          </li>

          {/*  */}

          <li>
            <a href="http://localhost:3000" title="通知">
              <img src={adviceIcon} alt="advice" />
            </a>
          </li>
          <li>
            <a href="http://localhost:2407/member/data" title="會員中心">
              <img src={memberIcon} alt="member" />
            </a>
          </li>
          <li>
            <a href="http://localhost:3000" title="購物車">
              <img src={cartIcon} alt="buy-cart" />
            </a>
          </li>
        </ul>
      </nav>
    </header>
  )
}

export default Head
