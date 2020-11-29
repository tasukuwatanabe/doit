import { mount } from '@vue/test-utils';
import ShortcutList from '@/shortcut-list'

describe('Testing App component', () => {
    it('is a Vue instance', () => {
      const wrapper = mount(ShortcutList)
      expect(wrapper.isVueInstance).toBeTruthy()
    })
})