import { mount } from '@vue/test-utils';
import LabelList from '@/label-list'

describe('Testing App component', () => {
    it('is a Vue instance', () => {
      const wrapper = mount(LabelList)
      expect(wrapper.isVueInstance).toBeTruthy()
    })
})