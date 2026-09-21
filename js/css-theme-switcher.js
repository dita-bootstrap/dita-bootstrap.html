/*!
 * CSS theme toggler for Bootstrap / Bootswatch
 */

(() => {
  'use strict';

  const getStoredCss = () => localStorage.getItem('css-theme');
  const setStoredCss = css => localStorage.setItem('css-theme', css);

  const getStoredColors = () => localStorage.getItem('css-colors');
  const setStoredColors = colors => localStorage.setItem('css-colors', colors);
  const removeStoredColors = () => localStorage.removeItem('css-colors');

  const setCss = css => {
      if (css) {
        const link = linkRegex(/.*\.min\.css/)[0];
        if (link) {
          if (link.getAttribute("href") === css) {
            return;
          }
          const body = document.querySelector('body');
          if (body) {
            body.style.visibility = "hidden";
          }
          link.removeAttribute("integrity");

          const handleLoad = () => {
            if (body) {
              body.style.visibility = "visible";
            }
          };
          link.addEventListener('load', handleLoad, { once: true });
          link.addEventListener('error', handleLoad, { once: true });
          // Fallback timeout in case load event is missed
          setTimeout(handleLoad, 1000);

          link.setAttribute("href", css);
        }
      }
  };

  const setColors = colors => {
    const link = linkRegex(/.*\.min\.css/)[0];
    const existing = document.querySelector('link[data-colors]');

    if (colors) {
      if (existing && existing.getAttribute('href') === colors) {
        return;
      }
      const target = existing || document.createElement('link');
      target.setAttribute('rel', 'stylesheet');
      target.setAttribute('data-colors', '');
      target.setAttribute('href', colors);
      if (link) {
        link.insertAdjacentElement('afterend', target);
      }
    } else if (existing) {
      existing.remove();
    }
  };

  const linkRegex = (regex) => {
    let output = [];
    for (let i of document.querySelectorAll('link')) {
        if (regex.test(i.href)) {
            output.push(i);
        }
    }
    return output;
  }

  const showActiveCss = (css, focus = false) => {
    const themeSwitcher = document.querySelector('#bd-css-theme');

    if (!themeSwitcher) {
      return;
    }

    const activeThemeIcon = document.querySelector('.theme-icon-active use');
    const btnToActive = document.querySelector(`[data-bs-css-href="${css}"]`);

    document.querySelectorAll('[data-bs-css-href]').forEach(element => {
      element.classList.remove('active');
      element.setAttribute('aria-pressed', 'false');
    });

    if (btnToActive) {
      btnToActive.classList.add('active');
      btnToActive.setAttribute('aria-pressed', 'true');
    }

    if (focus) {
      themeSwitcher.focus();
    }
  };

  window.addEventListener('DOMContentLoaded', () => {
    const stored = getStoredCss();
    const isAvailable = stored && Array.from(document.querySelectorAll('[data-bs-css-href]'))
      .some(toggle => toggle.getAttribute('data-bs-css-href') === stored);
    if (isAvailable) {
      showActiveCss(stored);
    }

    const storedColors = getStoredColors();
    if (storedColors) {
      setColors(storedColors);
    }

    document.querySelectorAll('[data-bs-css-href]').forEach(toggle => {
      toggle.addEventListener('click', () => {
        const css = toggle.getAttribute('data-bs-css-href');
        const colors = toggle.getAttribute('data-colors');

        setStoredCss(css);
        setCss(css);

        if (colors) {
          setStoredColors(colors);
        } else {
          removeStoredColors();
        }
        setColors(colors);

        showActiveCss(css, true);
      });
    });
  });
})();
